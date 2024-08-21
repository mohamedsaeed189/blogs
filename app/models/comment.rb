class Comment < ApplicationRecord
  # Associations
  belongs_to :blog
  belongs_to :user

  # Validations
  validates :content, presence: true
  
end
