class ApiController < ApplicationController

  include FbConnectionsHelper
  include ApplicationHelper
  require 'cgi'

  def save_score

    #TODO get decryption working correctly

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
      create_user_fb_connections_for_user fb_user
    end

    the_score = Score.where("score_fb_id = #{fb_id} and app_id = #{app.id} and level_id = '#{level_id}'")
    score_attrs = { :score => score, :level_id => level_id, :score_fb_id => fb_id, :app_id => app.id }

    if(the_score && the_score.any?)
      the_score = the_score.first
      the_score.update_attributes(score_attrs)
    else
      the_score = Score.create(score_attrs)
    end

    render :json => {:result => the_score }
  end

  def get_scores

      app = App.find_by_app_id(params[:app_id])

      conditions = "app_id = #{app.id} and level_id = '#{params[:level_id]}'"

      if(params[:fb_id])
        conditions = conditions + " and (score_fb_id in ( select fbc_fb_id from fb_connections where fbc_user_id = #{params[:fb_id]} ) or score_fb_id = #{params[:fb_id]})"
      end

      limit = 1000
      if(params[:limit])
         limit = params[:limit]
      end

      results = Score.joins(:fb_user).select("scores.*, name").where(conditions).limit(limit)

      render :json => results
  end

end
