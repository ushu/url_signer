require 'url_signer'
require 'ostruct'
require 'rails/railtie'

module UrlSigner

  module Rails
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        helper_method :sign_url
      end

      # Sign a +url+.
      #
      #   @signed_url = sign_url(some_route_helper_url)
      #
      # Can also be used as a view helper:
      #
      #   <%= link_to 'Some secret', sign_url(some_secret_action_url) %>
      #
      # For +options+, see UrlSigner#sign.
      def sign_url(url, options={})
        options = url_signer_options(options)
        UrlSigner.sign(url,  options).to_s
      end

      # Verify a +url+.
      #
      #   class MyController < ActionController::Base
      #     def my_action
      #
      #       # verify the validity of the current called url
      #       current_url_valid = signature_valid?
      #
      #       # or with another url
      #       orher_url_valid = signature_valid?(orher_url)
      #
      #     end
      #   end
      #
      # For +options+, see UrlSigner#valid?.
      def signature_valid?(url=nil, options={})
        url ||= request.url
        options = url_signer_options(options)
        UrlSigner.valid?(url, options)
      end

      # Verify the current url and call #signature_invalid! on failure.
      # This method is intended to be used in a before action.
      #
      #   class MyController < ActionController::Base
      #     before_action :verify_signature!
      #
      #     def secure_action
      #       # can only be accessed from a signed url
      #     end
      #   end
      def verify_signature!
        signature_invalid! unless signature_valid?
      end

      # Called when an action is called with an invalid signature attached.
      # Will be overridden to enhance behaviour:
      #
      #   class MyController < ActionController::Base
      #     before_action :verify_signature!
      #
      #     # ...
      #
      #     def signature_invalid!
      #       redirect_to root_path, notice: 'you URL is not valid anymore'
      #     end
      #   end
      def signature_invalid!
        head :forbidden
      end

      private

      def url_signer_options(options={}) # :nodoc:
        defaults = ::Rails.configuration.url_signer.defaults
        defaults.to_h.merge(options)
      end
    end

    class Railtie < ::Rails::Railtie # :nodoc:
      config.url_signer = ActiveSupport::OrderedOptions.new

      # setup sensible defaults
      config.url_signer.key = ENV['URL_SIGNING_KEY']
      config.url_signer.hash_method = Digest::SHA1
    end

  end
end

ActionController::Base.send(:include, UrlSigner::Rails::ControllerHelpers)
