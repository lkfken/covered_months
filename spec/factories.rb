require 'ostruct'

# This will guess the User class
FactoryGirl.define do
  factory :active_member, class: OpenStruct do
    dates [Date.civil(2016, 1, 1)..Date.civil(2999, 12, 31)]
  end
  factory :mid_year_member, class: OpenStruct do
    dates [Date.civil(2016, 2, 1)..Date.civil(2016, 5, 31)]
  end

  factory :partial_month_member, class: OpenStruct do
    dates [Date.civil(2016, 4, 1)..Date.civil(2016, 4, 15)]
  end

end