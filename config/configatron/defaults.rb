# Put all your default configatron settings here.

# Example:
#   configatron.emails.welcome.subject = 'Welcome!'
#   configatron.emails.sales_reciept.subject = 'Thanks for your order'
# 
#   configatron.file.storage = :s3

  # development (delivery):
  configatron.apn.passphrase  #=> ''
  configatron.apn.port  = 2195
  configatron.apn.host  = 'gateway.sandbox.push.apple.com'
  configatron.apn.cert #=> ''

  # production (delivery):
  configatron.apn.host  #=> 'gateway.push.apple.com'
  configatron.apn.cert #=> ''

  # development (feedback):
  configatron.apn.feedback.passphrase  #=> ''
  configatron.apn.feedback.port  #=> 2196
  configatron.apn.feedback.host  #=> 'feedback.sandbox.push.apple.com'
  configatron.apn.feedback.cert #=> ''

  # production (feedback):
  configatron.apn.feedback.host  #=> 'feedback.push.apple.com'
  configatron.apn.feedback.cert #=> ''