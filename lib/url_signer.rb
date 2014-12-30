module UrlSigner
  autoload :Signer, 'url_signer/signer'

  module_function

  def sign(url, *options)
    temp_signer = UrlSigner::Signer.new(*options)
    temp_signer.sign(url)
  end

  def valid?(url, *options)
    temp_signer = UrlSigner::Signer.new(*options)
    temp_signer.valid?(url)
  end

end
