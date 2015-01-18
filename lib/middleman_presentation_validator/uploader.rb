# encoding: utf-8
module MiddlemanPresentationValidator
  class Uploader

    def upload(callback_url, result)
      %w(http_proxy https_proxy).each { |v| ENV.delete(v) }

      conn = Excon.new callback_url
      conn.post(body: result, headers: { 'Content-Type': 'application/json' })

      self
    end
  end
end
