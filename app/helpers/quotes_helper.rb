module QuotesHelper

  class YTLinkValidator < ActiveModel::Validator
    def validate(record)

      begin
        urlid = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(record.url)[1]
      rescue NoMethodError
        record.errors[:url] << "Enter a YouTube video URL"
        return
      end
      uri = URI.parse("http://gdata.youtube.com/feeds/api/videos/#{ urlid }")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      code = %Q{ #{response.code} }
      if code.strip != "200"
        record.errors[:url] << code
      end

    end
  end

end


