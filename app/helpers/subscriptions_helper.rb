module SubscriptionsHelper

  def is_customer_deleted(stripe_customer_token)
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    return (!customer[:subscription] and customer[:deleted] == true)
  end

end
