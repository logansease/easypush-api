module FbConnectionsHelper
  def create_user_fb_connections_for_fb_user fb_user
        #send request to https://graph.facebook.com/me/friends?session_token=
        graph = Koala::Facebook::API.new(fb_user.token)
        results = graph.get_connections('me', 'friends')

        #for each id, insert to fb_friends, fb_id, id
        results.each do |result|
          FbConnection.create!(:fbc_user_id =>fb_user.fb_id, :fbc_fb_id => result["id"])
        end

        if current_user
          current_user.reload
        end
    end

end
