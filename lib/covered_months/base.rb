require 'kl/date_range'
require 'set'

module CoveredMonths
  class Base
    attr_reader :date_segments, :base_date_segment

    def initialize(date_segments:, base_date_segment:)
      @date_segments     = date_segments
      @base_date_segment = base_date_segment
    end

    def count
      to_hash.map do |month, day_count|
        base_month = Date.parse(month+'01')
        month_days = base_month.end_of_month.day
        Rational(day_count, month_days)
      end.inject(0.0) { |sum, frac| sum += frac }
    end

    def to_hash
      @value ||= begin
        days_within_base.inject(Hash.new) do |hsh, date|
          key      = date.strftime('%Y%m')
          hsh[key] ||= 0
          hsh[key] += 1
          hsh
        end
      end
    end

    def dates
      @range_dates ||= begin
        date_segments.inject([]) do |a, segment|
          segment = (base_date_segment.begin..segment.end) if segment.begin < base_date_segment.begin
          segment = (segment.begin..base_date_segment.end) if segment.end > base_date_segment.end
          a.concat(KL::DateRange(segment).every(:days => 1))
        end
      end
    end

    private

    def days_within_base
      base_date_segment_dates & dates
    end

    def base_date_segment_dates
      KL::DateRange(base_date_segment).every(:days => 1)
    end
  end
end