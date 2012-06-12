class PromoCodesController < ApplicationController

  #take the user to a page allowing them to enter a large
  #number of promo codes at once for a specific app
  def new
    @app = App.find(params[:app_id])
  end

  #find the app id and parse the string for separate codes
  #insert one for each
  #look at checked box asking users if they want to clear out their old codes
  def create

    invalidate = params[:clear_old_codes]
    if(invalidate)
      codes = PromoCode.where("app_id = #{params[:app_id]} and invalidated = ?", false)

      codes.each do |code|
        code.invalidated = true
        code.save!
      end
    end

    ids = params[:codes_text].split
    ids.each do |id|
        code = PromoCode.create
      code.app_id = params[:app_id]
      code.code= id
      code.save!
    end

      redirect_to :action => "index", :app_id => params[:app_id]
  end

  #delete by a list of IDs passed in
  def destroy

  end

  #load all the promo codes for a given app
  def index
      @app = App.find(params[:app_id])
      @promo_codes = PromoCode.find_all_by_app_id(params[:app_id])
  end


  #get the IP from the request
  #get the app key from the request.
  #confirm no codes have been redeemed by the current user
  #otherwise generate link for the promocode,
  #set redeemed by IP
  def redeem
    @app = App.find_by_app_id(params[:app_key])

    user_codes = PromoCode.where("app_id = #{@app.id} and invalidated = ? and claimed_by_ip = ?", false,request.env['REMOTE_ADDR'])
    if(!user_codes.empty?)
      @warning = "Sorry, only one promo code may be claimed per IP address."
      @code = user_codes.first
    else
      codes = PromoCode.where("app_id = #{@app.id} and invalidated = ? and claimed_by_ip is null", false)
          @code = codes.first
          if(@code)
            @code.claimed_by_ip = request.env['REMOTE_ADDR']
            @code.save!
          end
    end
  end

end
