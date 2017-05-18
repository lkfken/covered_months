require "spec_helper"

describe CoveredMonths do
  let(:start_date) { Date.civil(2016, 1, 1) }
  let(:end_date) { Date.civil(2016, 12, 31) }

  context 'active coverage' do
    let(:dates) { build(:active_member).dates }
    let(:covered_months) { CoveredMonths.create(dates: dates, date_range: (start_date..end_date)) }

    it '#range_dates' do
      expect(covered_months.range_dates.size).to eq(366)
    end

    it "#count" do
      expect(covered_months.count).to eq(12.0)
    end
  end

  context 'no complete coverage' do
    let(:dates) { build(:mid_year_member).dates }
    let(:covered_months) { CoveredMonths.create(dates: dates, date_range: (start_date..end_date)) }

    it '#range_dates' do
      expect(covered_months.range_dates.size).to eq(121)
    end

    it "#count" do
      expect(covered_months.count).to eq(4.0)
    end
  end

  context 'partial month coverage' do
    let(:dates) { build(:partial_month_member).dates }
    let(:covered_months) { CoveredMonths.create(dates: dates, date_range: (start_date..end_date)) }

    it '#range_dates' do
      expect(covered_months.range_dates.size).to eq(15)
    end

    it "#count" do
      expect(covered_months.count).to eq(0.5)
    end
  end
end
