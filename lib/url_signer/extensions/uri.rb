require 'uri'
require 'url_signer'

module URI
  class Generic

    # Return a signed version of the <tt>URI</tt>.
    #
    #   url = URI.parse('http://google.fr')
    #   signed_url = url.signed
    def signed(*options)
      UrlSigner.sign(self, *options)
    end

    # Checks the validity of the current <tt>URI</tt> signature.
    #
    #   signed_url = URI.parse('http://google.fr').signed
    #   signed_url.signature_valid? # => true
    def signature_valid?(*options)
      UrlSigner.valid?(self, *options)
    end

  end
end
