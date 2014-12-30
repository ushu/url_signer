module UrlSigner
  autoload :Base, 'url_signer/base'
  autoload :Signer, 'url_signer/signer'
  autoload :Verifier, 'url_signer/verifier'

  module_function

  def sign(url, *options)
    temp_signer = UrlSigner::Signer.new(url, *options)
    temp_signer.sign
  end

  def valid?(url, *options)
    temp_verifier = UrlSigner::Verifier.new(url, *options)
    temp_verifier.valid?
  end

end
