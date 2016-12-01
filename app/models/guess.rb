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

  def grade(answer)
    times_correct_increment = card.check(answer) ? 1 : -1
    times_correct += times_correct_increment
    repeat_at += REPEAT_INTERVALS[times_correct]
    save
  end
end