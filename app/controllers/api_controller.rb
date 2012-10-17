class ApiController < ApplicationController

  include FbConnectionsHelper
  include ApplicationHelper
  require 'cgi'

  def register_push

    app_id_param = params[:app_id]
    app = App.find_by_app_id(app_id_param)


    encoded64 = params[:data]
    encoded = Base64.decode64(encoded64 )

    data = decrypt(encoded, app.app_secret)

    parsed_json = ActiveSupport::JSON.decode(data)

    #get parameters
    device = parsed_json['device_id']
    fb_user = parsed_json['fb_user']
    app_id = parsed_json['app_id']


    if(app_id.to_s != app_id_param)
      render :json => {:result => "error app Ids dont match #{app_id.to_is} != #{app_id_param}"}
      return
    end

    if device.index("<") == 0
       device = device[1,device.length-1]
    end
    if device.index(">") == device.length-1
       device = device[0,device.length-1]
    end



    appNotifications =  PushNotificationId.find_all_by_app_id(app.id)
    if(!appNotifications || appNotifications.select{|notification| notification.device_id == device}.count <= 0)
      device = PushNotificationId.create!(:app_id => app.id, :device_id => device, :fb_user_id => fb_user)
      render :json => {"result" => "added"}
    else
      render :json => {"result" => "duplicate"}
    end

  end

end
