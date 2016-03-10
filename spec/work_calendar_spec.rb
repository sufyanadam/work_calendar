require_relative '../work_calendar'

describe WorkCalendar do
  before do
    described_class.reset_to_default_config!
  end

  describe ".configure" do
    subject { described_class.configure(&config_block) }

    let(:custom_weekdays) { %i[sat sun mon tue wed] }
    let(:custom_holidays) { [Date.new(2016, 1, 18)] }

    context "when provided with a configuration for only weekdays" do
      let(:config_block) { ->(config) { config.weekdays = custom_weekdays } }

      it "overrides the default weekdays with the ones provided" do
        subject
        expect(described_class.weekdays).to eq custom_weekdays
        expect(described_class.holidays).to eq described_class::DEFAULT_HOLIDAYS
      end
    end

    context "when provided with a configuration for only holidays" do
      let(:config_block) { ->(config) { config.holidays = custom_holidays } }

      it "overrides the default holidays with the ones provided" do
        subject
        expect(described_class.weekdays).to eq described_class::DEFAULT_WEEKDAYS
        expect(described_class.holidays).to eq custom_holidays
      end
    end

    context "when provided with a configuration for both weekdays and holidays" do
      let(:config_block) {
        ->(config) { config.holidays = custom_holidays; config.weekdays = custom_weekdays }
      }

      it "overrides both the default weekdays and default holidays with those provided" do
        subject
        expect(described_class.weekdays).to eq custom_weekdays
        expect(described_class.holidays).to eq custom_holidays
      end
    end
  end

  describe ".active?" do
    subject { described_class.active?(date) }

    context "when given a non-active work day" do
      context "such as new year's day" do
        let(:date) { Date.new(2015, 1, 1) }

        it { is_expected.to be false }
      end

      context "such as 2015-07-03" do
        let(:date) { Date.new(2015, 7, 3) }

        it { is_expected.to be false }
      end

      context "when the holiday and weekday configuration is overridden" do
        let(:custom_weekdays) { %i[sat sun mon tue wed thu] }
        let(:custom_holidays) { [Date.new(2016, 1, 18)] }

        before do
          described_class.configure do |c|
            c.weekdays = custom_weekdays
            c.holidays = custom_holidays
          end
        end

        context "when provided with a holiday date" do
          let(:date) { Date.new(2016, 1, 18) }

          it { is_expected.to be false }
        end

        context "when provided with a non-active date (a friday)" do
          let(:date) { Date.new(2016, 3, 11) }

          it { is_expected.to be false }
        end

        context "when provided with a non-active date from the DEFAULT configuration" do
          let(:date) { Date.new(2015, 1, 1) }

          it { is_expected.to be true }
        end

        context "when provided with an active date" do
          let(:date) { Date.new(2015, 6, 17) }

          it { is_expected.to be true }
        end
      end
    end

    context "when given an active work day" do
      let(:date) { Date.new(2015, 1, 2) }

      it { is_expected.to be true }
    end
  end

  describe ".days_before" do
    subject { described_class.days_before(5, date) }

    let(:date) { Date.new(2015, 1, 8) }

    it "returns the active date before the specified number of 'active' days for the given date" do
      expect(subject).to eq Date.parse('2014-12-31')
    end

    context "when the holiday and weekday configuration is overridden" do
      let(:custom_weekdays) { %i[sat sun mon tue wed thu] }
      let(:custom_holidays) { [Date.new(2016, 1, 18)] }

      before do
        described_class.configure do |c|
          c.weekdays = custom_weekdays
          c.holidays = custom_holidays
        end
      end

      it { is_expected.to eq Date.parse('2015-1-3') }
    end
  end

  describe ".days_after" do
    subject { described_class.days_after(5, Date.new(2015, 1, 1)) }

    let(:date) { Date.new(2015, 1, 1) }

    it "returns the active date after the specified number of 'active' days for the given date" do
      expect(subject).to eq Date.parse('2015-01-08')
    end

    context "when the holiday and weekday configuration is overridden" do
      let(:custom_weekdays) { %i[sat sun mon tue wed thu] }
      let(:custom_holidays) { [Date.new(2016, 1, 18)] }

      before do
        described_class.configure do |c|
          c.weekdays = custom_weekdays
          c.holidays = custom_holidays
        end
      end

      it { is_expected.to eq Date.parse('2015-1-7') }
    end
  end

  describe ".between" do
    subject { described_class.between(date1, date2) }

    let(:date1) { Date.new(2014, 12, 30) }
    let(:date2) { Date.new(2015,  1, 15) }

    it "returns the active dates between two dates, exclusive of the second date" do
      expected_result = [
        Date.parse('2014-12-30'),
        Date.parse('2014-12-31'),
        Date.parse('2015-01-02'),
        Date.parse('2015-01-05'),
        Date.parse('2015-01-06'),
        Date.parse('2015-01-07'),
        Date.parse('2015-01-08'),
        Date.parse('2015-01-09'),
        Date.parse('2015-01-12'),
        Date.parse('2015-01-13'),
        Date.parse('2015-01-14')
      ]

      expect(subject).to eq expected_result
    end

    context "when the holiday and weekday configuration is overridden" do
      let(:custom_weekdays) { %i[sat sun mon tue wed thu] }
      let(:custom_holidays) { [Date.new(2015, 1, 10)] }

      before do
        described_class.configure do |c|
          c.weekdays = custom_weekdays
          c.holidays = custom_holidays
        end
      end

      let(:expected_result) do
        [
          Date.parse('2014-12-30'),
          Date.parse('2014-12-31'),
          Date.parse('2015-01-01'),
          Date.parse('2015-01-03'),
          Date.parse('2015-01-04'),
          Date.parse('2015-01-05'),
          Date.parse('2015-01-06'),
          Date.parse('2015-01-07'),
          Date.parse('2015-01-08'),
          Date.parse('2015-01-11'),
          Date.parse('2015-01-12'),
          Date.parse('2015-01-13'),
          Date.parse('2015-01-14')
        ]
      end

      it { is_expected.to eq expected_result }
    end
  end
end
