module UrlSigner
  autoload :Signer, 'url_signer/signer'

  module_function

  def sign(url, *options)
    temp_signer = UrlSigner::Signer.new(url, *options)
    temp_signer.sign
  end

  def valid?(url, *options)
    temp_signer = UrlSigner::Signer.new(url, *options)
    temp_signer.valid?
  end

end
