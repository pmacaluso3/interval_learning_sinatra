class Guess < ActiveRecord::Base
  SECONDS_IN_AN_HOUR = 60*60
  HOURS_IN_A_DAY = 24
  REPEAT_INTERVALS = {
    0 => 0,
    1 => 1*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    2 => 2*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    3 => 3*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    4 => 5*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    5 => 7*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR
  }

  belongs_to :game
  belongs_to :card

  scope :due_to_repeat, -> { where('repeat_at < ?', Time.now) }

  validates :repeat_at, :times_correct, :game_id, :card_id, presence: true
  # TODO: validate uniqueness of card_id within scope of game
  # TODO: validate that times_correct is one of the enumerated acceptable integers

  before_validation :default_repeat_at # TODO: move to migration layer. may require manual sql execution in the migration file.

  def grade(answer)
    times_correct_increment = card.check(answer) ? 1 : -1
    self.times_correct += times_correct_increment
    self.times_correct = [times_correct, 0].max
    self.repeat_at = Time.now + REPEAT_INTERVALS[times_correct]
    save
  end

  def due_to_repeat?
    repeat_at < Time.now
  end

  private
  def default_repeat_at
    self.repeat_at ||= Time.now
  end
end
