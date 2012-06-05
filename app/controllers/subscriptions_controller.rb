class SubscriptionsController < ApplicationController

  include SubscriptionsHelper


  def new
    plan = Plan.find(params[:plan_id])
    if(current_user.subscription)
      @subscription = current_user.subscription
      @subscription.plan = plan
    else
      @subscription = plan.subscriptions.build
    end

  end

  def create

      @subscription = Subscription.new(params[:subscription])
      if @subscription.save_with_payment
        redirect_to @subscription, :notice => "Thank you for subscribing!"
      else
        render :new
      end

  end

  def update
    # throw params.inspect
    args = {}
    args[:plan] = params[:subscription][:plan_id]

    subscription = Subscription.find(params[:id] )
    subscription.plan_id = params[:subscription][:plan_id]

    if(params[:subscription][:stripe_card_token] and params[:subscription][:stripe_card_token].length > 0)
      args[:card] = params[:subscription][:stripe_card_token]
    end
     @customer = Stripe::Customer.retrieve(subscription.stripe_customer_token)
     @customer.update_subscription(args)
    @customer = Stripe::Customer.retrieve(subscription.stripe_customer_token)
    subscription.save!
    render 'manage'

  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def manage

      subscription = current_user.subscription
      if(!subscription)
        redirect_to "/plans/"
      elsif is_customer_deleted(current_user.subscription.stripe_customer_token)
          current_user.subscription.delete
          current_user.reload
        redirect_to "/plans"
      else
        #throw subscription
        @customer = Stripe::Customer.retrieve(subscription.stripe_customer_token)
      end

  end

  def destroy
    subscription = Subscription.find(params[:id])
    customer = Stripe::Customer.retrieve(subscription.stripe_customer_token)
    customer.cancel_subscription
    subscription.delete
  end

end
