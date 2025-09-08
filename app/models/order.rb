class Order < ApplicationRecord
  belongs_to :book
  
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_name, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  
  enum status: {
    pending: 'pending',
    paid: 'paid',
    failed: 'failed',
    cancelled: 'cancelled'
  }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: 'paid') }
  
  def mark_as_paid!
    update!(status: 'paid', purchased_at: Time.current)
  end
end
