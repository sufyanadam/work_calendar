require 'ostruct'
require 'date'

class WorkCalendar
  @config = OpenStruct.new({})

  DAY_MAP = { 0 => :sun, 1 => :mon, 2 => :tue, 3 => :wed, 4 => :thu, 5 => :fri, 6 => :sat }

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
    count_days_from(date, count, 'back')
  end

  def self.days_after(count, date)
    count_days_from(date, count, 'forward')
  end

  private_class_method def self.count_days_from(date, count, direction)
    new_date = date
    arithmetic_operation = (direction == 'back' ? :- : :+)

    count.times do
      new_date = new_date.send(arithmetic_operation, 1)

      while not active?(new_date)
        new_date = new_date.send(arithmetic_operation, 1)
      end
    end

    new_date
  end

  def self.between(date1, date2)
    (date1...date2).reject { |date| !active?(date) }
  end

  def self.weekdays
    @config.weekdays || DEFAULT_WEEKDAYS
  end

  def self.holidays
    @config.holidays || DEFAULT_HOLIDAYS
  end
end
