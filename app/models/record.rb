class Record < ApplicationRecord
  has_many :chunks
  accepts_nested_attributes_for :chunks
end
