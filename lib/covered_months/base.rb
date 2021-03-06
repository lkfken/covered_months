require 'kl/date_range'
require 'set'
require_relative 'cache'
require 'pp'

module CoveredMonths
  class Base
    attr_reader :date_segments, :base_date_segment
    attr_accessor :cache_enable

    def initialize(date_segments:, base_date_segment:, cache_enable: false)
      @date_segments     = date_segments
      @base_date_segment = base_date_segment
      @cached            = cache_enable
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
        dates_within_base.inject(Hash.new) do |hsh, date|
          key      = date.strftime('%Y%m')
          hsh[key] ||= 0
          hsh[key] += 1
          hsh
        end
      end
    end

    def dates
      @range_dates ||= truncated_date_segments.inject([]) { |a, segment| a.concat(segment_dates(segment)) }
    end

    private

    def segment_dates(segment)
      if cache_enable
        key = segment.to_yaml
        load_from_cache(key)
      else
        KL::DateRange(segment).every(:days => 1)
      end

    end

    def truncated_date_segments
      date_segments.map do |segment|
        segment = (base_date_segment.begin..segment.end) if segment.begin < base_date_segment.begin
        segment = (segment.begin..base_date_segment.end) if segment.end > base_date_segment.end
        segment
      end
    end

    def dates_within_base
      base_date_segment_dates & dates
    end

    def base_date_segment_dates
      if cache_enable
        key = base_date_segment.to_yaml
        load_from_cache(key)
      else
        KL::DateRange(base_date_segment).every(:days => 1)
      end
    end

    def load_from_cache(key)
      cached_record = Cache.find(key: key)
      if cached_record.nil?
        range = YAML::load(key)
        value = KL::DateRange(range).every(:days => 1)
        Cache.create(key: key, value: value.to_yaml)
        value
      else
        YAML::load(cached_record.value)
      end
    end
  end
end