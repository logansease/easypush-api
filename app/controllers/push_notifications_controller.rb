class PushNotificationsController < ApplicationController

  before_filter :authenticate
  before_filter :correct_user

  #load all the promo codes for a given app
  def index
    @devices = PushNotificationId.find_all_by_app_id(params[:app_id])
  end

  def create_message
    if(!@app.dev_push_cert || !@app.prod_push_cert)
      redirect_to(@app, :flash => {:success =>"Your app is not configured to send push notifications. Missing Certificates."} )
      return
    end

    @apn_app = APN::App.find_by_apn_dev_cert_and_apn_prod_cert(@app.dev_push_cert, @app.prod_push_cert)
    if(!@apn_app)
      @apn_app = APN::App.create!(:apn_dev_cert => @app.dev_push_cert, :apn_prod_cert => @app.prod_push_cert)
    end
    render 'create_message'
  end

  def send_message
    @apn_app = APN::App.find(params[:apn_app_id])

    #update the override_prod flag on the apn_app
    @apn_app.override_prod = params[:dev]
    @apn_app.save!
    begin

    #for each device in the app, create a notification
    devices = PushNotificationId.find_all_by_app_id(@app.id)
    devices.each do |device|
      apnDevice = APN::Device.find_by_token_and_app_id(device.device_id,@apn_app.id)
      if(!apnDevice)
        apnDevice = APN::Device.create(:token => device.device_id,:app_id => @apn_app.id)
      end
      newNotification = APN::Notification.new
      newNotification.device = apnDevice
      newNotification.badge =  params[:badge]
      newNotification.alert = params[:alert]
      if(params[:custom_properties])
        if props =  eval( params[:custom_properties])
          newNotification.custom_properties = props
        end
      end
      newNotification.sound = params[:sound]
      newNotification.save!
    end

    #call apn_app send

    @apn_app.send_notifications
    rescue Exception  => e
      puts e.message
      puts e.backtrace.inspect
      APN::Notification.delete(@apn_app.notifications.where(:sent_at => nil))
      redirect_to(@app, :flash => {:success =>"There was an error sending your notifications: " + e.message} )
      return
    end

    redirect_to(@app, :flash => {:success =>"Your push notification has been sent!"} )

  end

  private

  def correct_user
    @app = App.find(params[:app_id])
    redirect_to(root_path) unless current_user?(@app.user)
  end


end
