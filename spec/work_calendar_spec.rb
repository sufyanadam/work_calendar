require_relative '../work_calendar'

describe WorkCalendar do
  describe ".active?" do
    subject { WorkCalendar.active?(date) }

    context "when given a non-active work day" do
      context "such as new year's day" do
        let(:date) { Date.new(2015, 1, 1) }

        it { is_expected.to be false }
      end

      context "such as 2015-07-03" do
        let(:date) { Date.new(2015, 7, 3) }

        it { is_expected.to be false }
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
  end

  describe ".days_after" do
    subject { described_class.days_after(5, Date.new(2015, 1, 1)) }

    let(:date) { Date.new(2015, 1, 1) }

    it "returns the active date after the specified number of 'active' days for the given date" do
      expect(subject).to eq Date.parse('2015-01-08')
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
  end
end
