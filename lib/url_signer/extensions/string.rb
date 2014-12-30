require 'uri'
require 'url_signer'

class String

  # Return a signed <tt>URI</tt> form the current <tt>String</tt>.
  #
  #   'http://google.fr'.to_signed_uri # => <URI::HTTP...>
  #
  # for +options+ see UrlSigner#sign.
  def to_signed_uri(*options)
      UrlSigner.sign(self, *options)
  end

end
