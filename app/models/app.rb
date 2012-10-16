class App < ActiveRecord::Base
  belongs_to :user
  has_many :scores

  def generate_app_id
    self.app_id = rand(10 ** 10)
  end

  def generate_secret_key
    self.app_secret = Digest::SHA1.hexdigest("--#{Time.now.to_s}----")[0,32]
    #code = Digest::SHA1.hexdigest("--#{Time.now.to_s}----").unpack('a2'*32).map{|x| x.hex}.pack('c'*32)
    #self.app_secret = Base64.encode64(code)
  end

  def levels_for_app
    #use group by query to get unique fb ids grouped by level id for this app id from scores table
    Score.select("count(distinct score_fb_id) as score_fb_id, level_id, max(score) as score ").where("app_id = #{self.id}").group('level_id')
  end

  def scores_for_level (level_id)
    #filter all scores, return only those with the level id specified
    #self.scores.keep_if{ |score| score.level_id == level_id  }
    Score.where("level_id = ? and app_id = ?", level_id, self.id)
  end

  def fb_users
    FbUser.where( " fb_id in (select distinct ( score_fb_id ) from scores where app_id = " + self.id.to_s + ") ")
  end



end
