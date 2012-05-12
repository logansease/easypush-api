module ApplicationHelper    



  # Return a title on a per page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}" 
    end  
  end  
  
  def logo
       image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  def iparty
       image_tag("iparty.png", :alt => "Sample App", :class => "round")
  end
  
  def facebook_logo
       image_tag("facebook_logo.png", :alt => "Facebook login", :class => "logo", :width => 17, :height => 17)
  end

  def base64_url_decode(str)
     str += '=' * (4 - str.length.modulo(4))
     Base64.decode64(str.tr('-_','+/'))
   end


  def encrypt(unencrypted, key)
      c = OpenSSL::Cipher.new("aes-128-cbc")
      c.encrypt
      c.key = key
      e = c.update(unencrypted)
      e << c.final
      return e
  end

  def decrypt2(encrypted_attr, key)
      c = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
      c.decrypt
      c.key = key
      d = c.update(encrypted_attr)
      d << c.final
      return d
  end
  def decrypt( cipher, key )

      aes = OpenSSL::Cipher::Cipher.new( "aes-128-cbc" ).decrypt
      aes.iv = cipher.slice( 0, 16 )
      # don't slice the SHA256 output for AES256
      aes.key = ( Digest::SHA256.digest( key ) ).slice( 0, 16 )

      cipher = cipher.slice( 16..-1 )

      return aes.update( cipher ) + aes.final
  end
end

