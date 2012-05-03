class FbUser < ActiveRecord::Base

  has_many :fb_connections, :dependent =>:destroy,
            :foreign_key => "fbc_user_id", :primary_key => 'fb_id'

  has_many :fb_friends, :through => :fb_connections, :source => :fb_friends

  def create_user_fb_connections
      #send request to https://graph.facebook.com/me/friends?session_token=
      graph = Koala::Facebook::API.new(self.token)
      results = graph.get_connections('me', 'friends')

      #for each id, insert to fb_friends, fb_id, id
      results.each do |result|
        FbConnection.create!(:fbc_user_id =>self.fb_id, :fbc_fb_id => result["id"])
      end

    self.reload
  end

  def remove_user_fb_connections
    FbConnection.destroy_all(:fbc_user_id =>self.fb_id)
    self.reload
  end

end
