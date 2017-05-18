require 'sequel'
require 'yaml'

DB = Sequel.connect('jdbc:sqlite::memory:')

DB.create_table(:records) do
  Integer :id, :primary_key => true
  String :key, :null => false
  String :value
end

module CoveredMonths
  class Cache < Sequel::Model
    set_dataset :records
  end
end