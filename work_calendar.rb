require 'ostruct'
require 'date'

class WorkCalendar
  DAY_MAP = {
    0 => :sun,
    1 => :mon,
    2 => :tue,
    3 => :wed,
    4 => :thu,
    5 => :fri,
    6 => :sat
  }

  DEFAULT_WEEKDAYS = %i[mon tue wed thu fri]
  DEFAULT_HOLIDAYS = [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)]

  def self.active?(date)
    return false if holidays.include?(date)

    weekdays.include?(DAY_MAP[date.wday])
  end

  def self.days_before(count, date)
    date_before = date

    count.times do
      date_before -= 1

      while not active?(date_before)
        date_before -= 1
      end
    end

    date_before
  end

  def self.weekdays
    DEFAULT_WEEKDAYS
  end

  def self.holidays
    DEFAULT_HOLIDAYS
  end
end
