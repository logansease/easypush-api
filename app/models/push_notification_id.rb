class PushNotificationId < ActiveRecord::Base
  belongs_to :fb_user
  belongs_to :app

  validates_presence_of :device_id, :app

end
