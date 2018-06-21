class Tag < ApplicationRecord
	has_many :taggings, dependent: :destroy
  	has_many :videos, through: :taggings
end
