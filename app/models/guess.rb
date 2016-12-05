class Guess < ActiveRecord::Base
  SECONDS_IN_AN_HOUR = 60*60
  HOURS_IN_A_DAY = 24
  REPEAT_INTERVALS = {
    0 => 0,
    1 => 1*SECONDS_IN_AN_HOUR,
    2 => 12*SECONDS_IN_AN_HOUR,
    3 => 24*SECONDS_IN_AN_HOUR,
    4 => 2*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    5 => 3*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR,
    6 => 5*HOURS_IN_A_DAY*SECONDS_IN_AN_HOUR
  }

  belongs_to :game
  belongs_to :card

  scope :due_to_repeat, -> { repeat_at < Time.now }

  validates :repeat_at, :times_correct, :game_id, :card_id, presence: true

  before_save :default_repeat_at # TODO: move to migration layer. may require manual sql execution in the migration file.

  def grade(answer)
    times_correct_increment = card.check(answer) ? 1 : -1
    times_correct += times_correct_increment
    repeat_at += REPEAT_INTERVALS[times_correct]
    save
  end

  def default_repeat_at
    self.repeat_at ||= Time.now
  end
end
