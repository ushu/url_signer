require 'url_signer'

module UrlSigner
  module Rails
    extend ActiveSupport::Concern

    def sign_url(url, options={})
      UrlSigner.sign(url, url_signer_options(options))
    end

    def signature_valid?(url=nil, options={})
      url ||= request.url
      UrlSigner.valid?(url, url_signer_options(options))
    end

    def verify_signature!
      head :forbidden unless signature_valid?
    end

    private

    def url_signer_options(provided_options)
      defaults = Rails.configuration.url_signer.defaults
      defaults.merge(provided_options)
    end

  end
end

# setup sensible defaults
Rails.configuration.url_signer = {}
Rails.configuration.url_signer.defaults = {
  key: ENV['URL_SIGNING_KEY'],
  hash_method: Digest::SHA1
}

ActiveController::Base.send(:include, ::UrlSigner::Rails)
