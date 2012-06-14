class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user

  validates_presence_of :plan_id
  validates_presence_of :user_id
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(email: self.email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def is_deleted
    customer = Stripe::Customer.retrieve(self.stripe_customer_token)
    return (!customer[:subscription] and customer[:deleted] == true)
  end

end
