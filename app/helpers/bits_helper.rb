module BitsHelper

  def set_bit_dependents(bitStructure)

    if bitStructure.respond_to?(:each) # if there are multiple bits

      bitStructure.each do |bit|

        if bit.user_id == 0 # if the user_id was set to 0, make the bit anonymous
          bit.set_anonymous(true)
        else
          bit.setUsername(User.find(bit.user_id).username)
        end
      end

    else # if there is only one bit

      if bitStructure.user_id == '0'
        bitStructure.set_anonymous(true)
      else
        bitStructure.setUsername(User.find(bitStructure.user_id).username)
      end
    end

  end

  def mute_cookie
    if cookies[:muted].blank?
      cookies[:muted] = true
    end
  end

  def set_username(bitStructure)
    if bitStructure.respond_to?(:each)
      bitStructure.each do |bit|
        bit.setUsername(User.find(bit.user_id).username)
      end
    else
      bitStructure.setUsername(User.find(bitStructure.user_id).username)
    end

  end

  def not_found(msg = 'Not found.')
    raise ActionController::RoutingError.new(msg)
  end

  def signed_in_bit_params
    hash = params.require(:bit).permit(:url, :start, :title, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:bit].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash
  end

  def signed_out_bit_params
    hash = params.require(:bit).permit(:url, :start, :title, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:bit].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash[:user_id] = '0'
    hash
  end

  class YTLinkValidator < ActiveModel::Validator
    def validate(record)

      begin
        urlid = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(record.url)[1]
      rescue NoMethodError
        record.errors[:url] << "Please enter a valid YouTube video URL"
        return
      end
      uri = URI.parse("http://gdata.youtube.com/feeds/api/videos/#{ urlid }")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      code = %Q{ #{response.code} }
      if code.strip != "200"
        record.errors[:url] << "Please enter a valid YouTube video URL"
      end

    end
  end

end


