require_relative 'covered_months/version'
require_relative 'covered_months/base'

module CoveredMonths
  def create(date_segments:, base_date_segment:)
    CoveredMonths::Base.new(date_segments: date_segments, base_date_segment: base_date_segment)
  end

  module_function :create
end
