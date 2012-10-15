class ApiController < ApplicationController

  include FbConnectionsHelper
  include ApplicationHelper
  require 'cgi'


  def save_user

    app_id_param = params[:app_id]
    app = App.find_by_app_id(app_id_param)


    encoded64 = params[:data]
    encoded = Base64.decode64(encoded64 )

    data = decrypt(encoded, app.app_secret)

    parsed_json = ActiveSupport::JSON.decode(data)

    app_id = parsed_json['app_id']
    token = parsed_json['token']

    if(app_id.to_s != app_id_param)
      render :json => {:result => "error app Ids dont match #{app_id.to_is} != #{app_id_param}"}
      return
    end

    graph = Koala::Facebook::API.new(token)
        results = graph.get_object("me")
        name = results["name"]
        fb_id = results["id"]
        email = results["email"]

        fb_user = FbUser.find_by_fb_id(fb_id)
        if(!fb_user)
          fb_user = FbUser.create(:token => token, :name => name, :fb_id => fb_id, :email => email)
          create_user_fb_connections_for_fb_user fb_user
        end
    render :json => fb_user

  end

  def save_score

    app_id_param = params[:app_id]
    app = App.find_by_app_id(app_id_param)


    encoded64 = params[:data]
    encoded = Base64.decode64(encoded64 )

    data = decrypt(encoded, app.app_secret)

    parsed_json = ActiveSupport::JSON.decode(data)

    score = parsed_json['score']
    level_id = parsed_json['level_id']
    app_id = parsed_json['app_id']
    token = parsed_json['token']

    if(app_id.to_s != app_id_param)
      render :json => {:result => "error app Ids dont match #{app_id.to_is} != #{app_id_param}"}
      return
    end

    graph = Koala::Facebook::API.new(token)
    results = graph.get_object("me")
    name = results["name"]
    fb_id = results["id"]
    email = results["email"]

    fb_user = FbUser.find_by_fb_id(fb_id)
    if(!fb_user)
      fb_user = FbUser.create(:token => token, :name => name, :fb_id => fb_id, :email => email)
      create_user_fb_connections_for_fb_user fb_user
    end

    the_score = Score.where("score_fb_id = #{fb_id} and app_id = #{app.id} and level_id = '#{level_id}'")
    score_attrs = { :score => score, :level_id => level_id, :score_fb_id => fb_id, :app_id => app.id }

    if(the_score && the_score.any?)
      the_score = the_score.first
      if the_score.score < score
        the_score.update_attributes(score_attrs)
      end
    else
      the_score = Score.create(score_attrs)
    end

    render :json => {:result => the_score }
  end


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

    if device.index "<" == 0
       device = device[1,device.length-1]
    end
    if device.index ">" == device.length-1
       device = device[0,device.length-1]
    end



    appNotifications =  PushNotificationId.find_by_app_id(app_id_param)
    if(!appNotifications || appNotifications.select{|notification| notification.device_id == device}.count <= 0)
      device = PushNotificationId.create!(:app_id => app.id, :device_id => device, :fb_user_id => fb_user)
    end

    render :json => {"success" => "true"}

  end

  def get_scores

      app = App.find_by_app_id(params[:app_id])

      conditions = "app_id = #{app.id} and level_id = '#{params[:level_id]}'"

      limit = 1000
      if(params[:limit])
           limit = params[:limit]
      end

      fb_results = ""
      if(params[:fb_id])
        fb_conditions = " and (score_fb_id in ( select fbc_fb_id from fb_connections where fbc_user_id = #{params[:fb_id]} ) or score_fb_id = #{params[:fb_id]})"
        fb_results = Score.joins(:fb_user).select("scores.*, name").where(conditions + fb_conditions).limit(limit)
      end

      results = Score.joins(:fb_user).select("scores.*, name").where(conditions).limit(limit)

      render :json => {:fb_scores => fb_results, :scores => results}
  end

end
