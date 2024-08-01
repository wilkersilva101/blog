class Article < ApplicationRecord

  belongs_to :user
  validates :title, presence: true


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "text", "title", "updated_at", "user_id"]
  end
end
