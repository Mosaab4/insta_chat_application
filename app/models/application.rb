class Application < ApplicationRecord
  validates_uniqueness_of :name
end
