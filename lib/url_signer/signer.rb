require 'url_signer/base'

module UrlSigner
  class Signer < Base

    def sign
      raise "this URL is already signed !" if signed?

      # build new url
      signed_url = url.dup
      signed_url.query = extended_query
      signed_url
    end

    private

    def extended_query
      base_query = query ? query + '&' : ''
      base_query + "signature=#{signature}"
    end

  end
end
