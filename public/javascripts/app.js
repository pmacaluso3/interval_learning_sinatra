var CardQueue = function(cards) {
  this.upcomingCards = cards;
  this.finshedCards = [];
  this.previousCard = null;
  this.currentCard = cards.splice(0,1);
}

CardQueue.prototype.advance = function() {
  this.previousCard.hideCard();
  this.finishedCards.push(this.previousCard);

  this.currentCard.moveToPrevious();
  this.currentCard.check();
  this.previousCard = this.currentCard;

  var newCurrentCard = this.upcomingCards.splice(0,1)
  newCurrentCard.moveToCurrent();
  this.currentCard = newCurrentCard;
}


var Card = function(cardDom) {
  this.$cardDom = $(cardDom);
  this.question = this.$cardDom.find('.card-quiz-question').text();
  this.correctAnswer = this.$cardDom.data('answer'); // TODO: bake this into the dom so it can be revealed when .correct is applied
  this.$incorrectAnswerBucket = this.$cardDom.find('.incorrect-answer-bucket')
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

Card.prototype.submittedAnswer = function() {
  this.$cardDom.find('.card-quiz-answer').val();
}

Card.prototype.stripClasses = function() {
  for(var i = 0; i < this.CLASSES_TO_STRIP.length; i++) {
    this.$cardDom.removeClass(this.CLASSES_TO_STRIP[i]);
  }
}

Card.prototype.moveToCurrent = function() {
  this.stripClasses();
  this.$cardDom.addClass('card-quiz-current');
}

Card.prototype.moveToPrevious = function() {
  this.stripClasses();
  this.$cardDom.addClass('card-quiz-previous');
}

Card.prototype.hideCard = function() {
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
  for (var i = 0; i < $cardDoms.length; i++) {
    cards.push(new Card($cardDoms[i]));
  }
  var cq = new CardQueue(cards);

  // allow enter-button submission
  // refocus on answer input after submission
  $('.next-question-button').on('click', function(event) {
    event.preventDefault();
    $card = $(event.delegateTarget).closest('.card-quiz');
    answer = $card.data('answer');
    // debugger

  })
})
