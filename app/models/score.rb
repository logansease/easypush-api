class Score < ActiveRecord::Base
  belongs_to :fb_user, :foreign_key => "score_fb_id", :primary_key => 'fb_id'
  belongs_to :app

  default_scope :order => "score DESC"

end
