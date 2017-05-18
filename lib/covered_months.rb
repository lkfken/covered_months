require_relative 'covered_months/version'
require_relative 'covered_months/base'

module CoveredMonths
  def create(dates:, date_range:)
    CoveredMonths::Base.new(date_segments: dates, base_date_segment: date_range)
  end

  module_function :create
end
