var CardQueue = function(cards) {
  this.upcomingCards = cards;
  this.currentCard = cards.splice(0,1)[0];
  this.currentCard.markAsCurrent();
  this.previousCard = null;
  this.finishedCards = [];
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
    this.currentCard = newCurrentCard;
  } else {
    this.concludeGame();
  }
}

CardQueue.prototype.concludeGame = function() {
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
  this.correctAnswer = this.$cardDom.find('.card-quiz-correct-answer').text(); // TODO: bake this into the dom so it can be revealed when .correct is applied
  this.$incorrectAnswerBucket = this.$cardDom.find('.card-quiz-incorrect-answer-bucket')
  this.CLASSES_TO_STRIP = ['card-quiz-hidden',
                           'card-quiz-current',
                           'card-quiz-previous'];
};

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

$(function() {
  var cards = [];
  var $cardDoms = $('.card-quiz');

  if ($cardDoms.length === 0) {
    return null
  }

  for (var i = 0; i < $cardDoms.length; i++) {
    cards.push(new Card($cardDoms[i]));
  }
  var cq = new CardQueue(cards);
  $('#next-question-button').on('click', function(event) {
    event.preventDefault();
    cq.advance();
    // TODO refocus on answer input after submission
    // TODO reset timer
  })

  $('#conclude-game-button').on('click', function(event) {
    event.preventDefault();
    cq.concludeGame();    
  })
  // TODO: timer
})
