var Card = function(cardDom) {
  this.$cardDom = $(cardDom);
  this.question = this.$cardDom.find('.card-quiz-question').text();
  this.correctAnswer = this.$cardDom.data('answer');
};

Card.prototype.check = function(successCallback, failCallback) {
  debugger //what's this
  var testAnswer = this.$cardDom.find('.card-quiz-answer').val();
  if (testAnswer === this.correctAnswer) {
    successCallback();
  } else {
    failCallback();
  }
}

Card.prototype.moveToCurrent = function() {
  this.$cardDom.removeClass('cardQuizHidden');
  this.$cardDom.removeClass('cardQuizPrevious');
  this.$cardDom.add
}

Card.prototype.moveToPrevious = function() {

}

Card.prototype.hide = function() {

}

Card.prototype.advancePosition = function

$(function() {
  $('.next-question-button').on('click', function(event) {
    event.preventDefault();
    $card = $(event.delegateTarget).closest('.card-quiz');
    answer = $card.data('answer');

    debugger
  })
  // PICKUP
})
