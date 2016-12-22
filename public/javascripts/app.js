var CardQueue = function(cards, timer) {
  this.upcomingCards = cards;
  this.currentCard = cards.splice(0,1)[0];
  this.currentCard.markAsCurrent();
  this.previousCard = null;
  this.finishedCards = [];
  this.timer = timer;
}

CardQueue.prototype.advance = function() {
  if (this.previousCard) {
    this.previousCard.markAsFinished();
    this.finishedCards.push(this.previousCard);
  }

  this.currentCard.markAsPrevious();
  this.currentCard.check();
  this.previousCard = this.currentCard;

  var newCurrentCard = this.upcomingCards.splice(0,1)[0]
  if (newCurrentCard) {
    newCurrentCard.markAsCurrent();
    newCurrentCard.focusOnInput();
    this.currentCard = newCurrentCard;
  } else {
    this.concludeGame();
  }
}

CardQueue.prototype.concludeGame = function() {
  this.timer.stopTimer.bind(this.timer)();

  var $form  = $('#game-show'),
      url    = $form.attr('action'),
      method = $form.find('input[name=_method]').attr('value'),
      data   = this.dataToSubmit()

  $.ajax({
    url: url,
    method: method,
    data: data
  })
  .done(function(response) {
    $(document).find('body').html(response);
  })
}

CardQueue.prototype.dataToSubmit = function() {
  var outputData = { cards: {} }
  for (var i = 0; i < this.cardsToSubmit().length; i++) {
    var card = this.cardsToSubmit()[i];
    outputData.cards[card.cardId()] = { answer: card.submittedAnswer() }
  }
  return outputData;
}

CardQueue.prototype.cardsToSubmit = function() {
  if (this.previousCard) {
    return this.finishedCards.concat([this.previousCard])
  } else {
    return this.finishedCards
  }
}

var Card = function(cardDom) {
  this.$cardDom = $(cardDom);
  this.question = this.$cardDom.find('.card-quiz-question').text();
  this.correctAnswer = this.$cardDom.find('.card-quiz-correct-answer').text();
  this.$incorrectAnswerBucket = this.$cardDom.find('.card-quiz-incorrect-answer-bucket')
  this.CLASSES_TO_STRIP = ['card-quiz-hidden',
                           'card-quiz-current',
                           'card-quiz-previous'];
};

Card.prototype.focusOnInput = function() {
  this.$cardDom.find('.card-quiz-submitted-answer').focus();
}

Card.prototype.check = function() {
  if (this.submittedAnswer() === this.correctAnswer) {
    this.markCorrect();
  } else {
    this.markIncorrect();
  }
}

Card.prototype.cardId = function () {
  return this.$cardDom.find('.card-quiz-submitted-answer').data('card-id')
}

Card.prototype.submittedAnswer = function() {
  return this.$cardDom.find('.card-quiz-submitted-answer').val();
}

Card.prototype.stripClasses = function() {
  for(var i = 0; i < this.CLASSES_TO_STRIP.length; i++) {
    this.$cardDom.removeClass(this.CLASSES_TO_STRIP[i]);
  }
}

Card.prototype.markAsCurrent = function() {
  this.stripClasses();
  this.$cardDom.addClass('card-quiz-current');
}

Card.prototype.markAsPrevious = function() {
  this.stripClasses();
  this.$cardDom.addClass('card-quiz-previous');
}

Card.prototype.markAsFinished = function() {
  this.stripClasses();
  this.$cardDom.addClass('card-quiz-hidden');
}

Card.prototype.markCorrect = function() {
  this.$cardDom.addClass('correct');
}

Card.prototype.markIncorrect = function() {
  this.$incorrectAnswerBucket.text(this.submittedAnswer());
  this.$cardDom.addClass('incorrect');
}

GameTimer = function(maxSeconds, selector) {
  if (maxSeconds === undefined) {
    maxSeconds = 5;
  }
  if (selector === undefined) {
    selector = '#game-timer';
  }
  this.callback = null;
  this.maxSeconds = maxSeconds;
  this.seconds = this.maxSeconds;
  this.$timerDom = $(selector);
  this.interval = null
}

GameTimer.prototype.setCallback = function(callback) {
  this.callback = callback;
}

GameTimer.prototype.startTimer = function() {
  this.$timerDom.text(this.seconds);
  this.interval = setInterval(this.countDown.bind(this), 1000);
}

GameTimer.prototype.countDown = function() {
  this.seconds --;
  if (this.seconds === 0) {
    this.callback();
  }
  this.$timerDom.text(this.seconds);
}

GameTimer.prototype.resetTimer = function() {
  this.seconds = this.maxSeconds;
}

GameTimer.prototype.stopTimer = function() {
  window.clearInterval(this.interval);
}

$(function() {
  var cards = [];
  var $cardDoms = $('.card-quiz');

  if ($cardDoms.length !== 0) {
    for (var i = 0; i < $cardDoms.length; i++) {
      cards.push(new Card($cardDoms[i]));
    }

    var timer = new GameTimer();
    var cq = new CardQueue(cards, timer);

    timer.setCallback(function() {
      cq.advance.bind(cq)();
      timer.resetTimer();
    });

    timer.startTimer();

    $('#next-question-button').on('click', function(event) {
      event.preventDefault();
      cq.advance();
      timer.resetTimer();
    })

    $('#conclude-game-button').on('click', function(event) {
      event.preventDefault();
      cq.concludeGame();
    })

    window.onbeforeunload = timer.stopTimer.bind(timer);
  }

  $('#cards-index-new-card-form .card-form').on('submit', function(event) {
    event.preventDefault();
    var $form = $(event.delegateTarget);
    var url = $form.attr('action')
    var method = $form.find('[name=_method]').attr('value') || $form.attr('method')

    $.ajax({
      url: url,
      method: method,
      data: $form.serialize()
    }).done(function(response) {
      $('.cards-index-single-row').first().before(response);
      $('#cards-index-new-card-form .card-form').trigger('reset');
      $('#refocus-input').focus();
    })
  })
})
