# encoding: utf-8
module MiddlemanPresentationValidator
  class Uploader
    private

    attr_reader :uploader, :payload

    public

    def initialize
      @uploader = Faraday.new do |conn|
        # POST/PUT params encoders:
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
      end

      @payload = {}
    end

    def upload(callback_url, zip_file)
      payload[:presentation] = Faraday::UploadIO.new(zip_file, 'application/zip')
      conn.post callback_url, payload
    end
  end
end
