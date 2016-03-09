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
end
