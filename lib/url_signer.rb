require 'uri'
require 'cgi'
require 'digest/hmac'
require 'digest/sha1'

class UrlSigner < Struct.new(:key, :hash_method)
  def initialize(key: nil, hash_method: nil)
    key ||= ENV['URL_SIGNING_KEY']
    raise "You need to provided a signing key to your UrlSigner instance" unless key

    hash_method ||= Digest::SHA1

    super(key, hash_method)
  end

  def sign(url)
    url = URI.parse(url) if url.kind_of?(String)
    raise "expecting a String or URI instance" unless url.kind_of?(URI)
    raise "this URL is already signed !" if signed?(url)

    # compute signature
    signature = signature_for_url(url)

    # build new url
    signed_url = url.dup
    signed_url.query = extend_query(url.query, signature)
    signed_url
  end

  def valid?(url)
    return false unless signed?(url)

    params = params_from_query(url.query)
    signature = params.delete('signature')
    recomputed_signature = compute_signature(url.host, url.path, params)

    safe_compare(signature, recomputed_signature)
  end

  def signature_for_url(url)
    params = params_from_query(url.query)
    compute_signature(url.host, url.path, params)
  end

  private

  def extend_query(query, signature)
    base_query = query ? query + '&' : ''
    return base_query + "signature=#{signature}"
  end

  def params_from_query(query)
    params = CGI.parse(query)
    Hash[params.map { |k,v| v.size == 1 ? [k, v[0]] : [k, v] }]
  end

  def compute_signature(host, path, params)
    keys = params.keys.sort
    query_string = keys.map { |k| "#{CGI.escape(k)}=#{CGI.escape(params[k])}" }.join
    base_string = "#{CGI.escape(host)}&#{CGI.escape(path)}&#{CGI.escape(query_string)}"

    signature = Digest::HMAC.hexdigest(base_string, key, hash_method)
    return signature
  end

  def signed?(url)
    params = params_from_query(url.query)
    params.has_key?('signature')
  end

  def safe_compare(signature, other_signature)
    hash_method.digest(signature) == hash_method.digest(other_signature)
  end

end
