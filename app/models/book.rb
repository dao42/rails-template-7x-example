class Book < ApplicationRecord
  has_many :orders, dependent: :destroy
  
  validates :title, presence: true
  validates :author, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :available, -> { where('stock > 0') }
  scope :by_author, ->(author) { where(author: author) }
  
  def available?
    stock > 0
  end
  
  def price_in_cents
    (price * 100).to_i
  end
  
  def cover_image_url
    cover_image.presence || "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=600&fit=crop"
  end
end
