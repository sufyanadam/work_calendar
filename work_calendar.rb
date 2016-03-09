require 'ostruct'
require 'date'

class WorkCalendar
  @config = OpenStruct.new({})

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

  def self.configure(&block)
    yield @config

    @config
  end

  def self.reset_to_default_config!
    @config = OpenStruct.new({})
  end

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

  def self.days_after(count, date)
    date_after = date

    count.times do
      date_after += 1

      while not active?(date_after)
        date_after += 1
      end
    end

    date_after
  end

  def self.between(date1, date2)
    (date1...date2).reject do |date|
      !active?(date)
    end
  end

  def self.weekdays
    @config.weekdays || DEFAULT_WEEKDAYS
  end

  def self.holidays
    @config.holidays || DEFAULT_HOLIDAYS
  end
end
