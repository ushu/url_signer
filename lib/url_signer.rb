# Sign and verify URLs
module UrlSigner
  autoload :Base, 'url_signer/base'
  autoload :Signer, 'url_signer/signer'
  autoload :Verifier, 'url_signer/verifier'

  module_function

  # Returns a new <tt>URI</tt> instance by appending a <tt>signature</tt> parameter to the query of +url+.
  # The method accepts that +url+ can be either a <tt>String</tt> or a <tt>URI</tt> instance.
  #
  #   signed_url = UrlSigner.sign('http://google.fr&q=test') # => <URI::HTTP...>
  #
  # The following key/value parameters can be given to +options+:
  # * <tt>:key</tt> - the secret key used for encryption
  # * <tt>:hash_method</tt> - the hash function to pass to <tt>Digest::HMAC</tt>. Defaults to <tt>Digest::SHA1</tt>.
  #
  # Note that if a +URL_SIGNING_KEY+ environment variable is defined, it will be used as a default value for the +:key+ option.
  def sign(url, *options)
    temp_signer = UrlSigner::Signer.new(url, *options)
    temp_signer.sign
  end

  # Verify the authenticity of the +url+ by checking the value of the <tt>signature</tt> query parameter (if present).
  # The method accepts that +url+ can be either a <tt>String</tt> or a <tt>URI</tt> instance.
  #
  # The following key/value parameters can be given to +options+:
  # * <tt>:key</tt> - the secret key used for encryption
  # * <tt>:hash_method</tt> - the hash function to pass to <tt>Digest::HMAC</tt>. Defaults to <tt>Digest::SHA1</tt>.
  #
  # Note that if a +URL_SIGNING_KEY+ environment variable is defined, it will be used as a default value for the +:key+ option.
  #
  # ==== Examples
  #
  #   dummy_url = 'http://google.fr?q=test
  #   UrlSigner.valid?(dummy_url) # => false
  #
  #   signed_url = UrlSigner.sign('http://google.fr&q=test')
  #   UrlSigner.valid?(signed_url) # => true
  def valid?(url, *options)
    temp_verifier = UrlSigner::Verifier.new(url, *options)
    temp_verifier.valid?
  end

end

# Insert helpers in URI
require 'url_signer/extensions/uri'
# Insert helpers in Rails controllers
require 'url_signer/extensions/rails' if defined?(Rails)
