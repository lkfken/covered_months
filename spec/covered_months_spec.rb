require "spec_helper"

describe CoveredMonths do
  let(:start_date) { Date.civil(2016, 1, 1) }
  let(:end_date) { Date.civil(2016, 12, 31) }

  context 'active coverage' do
    let(:date_segments) { build(:active_member).dates }
    let(:covered_months) { CoveredMonths.create(date_segments: date_segments, base_date_segment: (start_date..end_date)) }

    it '#dates' do
      expect(covered_months.dates.size).to eq(366)
    end

    it '#count' do
      expect(covered_months.count).to eq(12.0)
    end
  end

  context 'no complete coverage' do
    let(:date_segments) { build(:mid_year_member).dates }
    let(:covered_months) { CoveredMonths.create(date_segments: date_segments, base_date_segment: (start_date..end_date)) }

    it '#dates' do
      expect(covered_months.dates.size).to eq(121)
    end

    it '#count' do
      expect(covered_months.count).to eq(4.0)
    end
  end

  context 'partial month coverage' do
    let(:date_segments) { build(:partial_month_member).dates }
    let(:covered_months) { CoveredMonths.create(date_segments: date_segments, base_date_segment: (start_date..end_date)) }

    it '#dates' do
      expect(covered_months.dates.size).to eq(15)
    end

    it '#count' do
      expect(covered_months.count).to eq(0.5)
    end
  end

  context 'multiple segments coverage' do
    let(:date_segments) { build(:multiple_segments_member).dates }
    let(:covered_months) { CoveredMonths.create(date_segments: date_segments, base_date_segment: (start_date..end_date)) }

    it '#dates' do
      expect(covered_months.dates.size).to eq(30)
    end

    it '#count' do
      expect(covered_months.count).to eq(1.0)
    end
  end

  context 'over edge segments coverage' do
    let(:date_segments) { build(:over_edge_segments_member).dates }
    let(:covered_months) { CoveredMonths.create(date_segments: date_segments, base_date_segment: (start_date..end_date)) }

    it '#dates' do
      expect(covered_months.dates.size).to eq(123)
    end

    it '#count' do
      expect(covered_months.count).to eq(4.0)
    end
  end

end
