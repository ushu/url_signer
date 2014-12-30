require 'uri'
require 'cgi'
require 'digest/hmac'
require 'digest/sha1'

module UrlSigner

  class Base < Struct.new(:url, :key, :hash_method) # :nodoc:

    def initialize(url, key: nil, hash_method: nil)
      # load and check url
      url = URI.parse(url) if url.kind_of?(String)
      raise "expecting a String or URI instance" unless url.kind_of?(URI)

      # load and check signing key
      key ||= ENV['URL_SIGNING_KEY']
      raise "You need to provided a signing key to your UrlSigner instance" unless key

      # load the hash method
      hash_method ||= Digest::SHA1

      super(url, key, hash_method)
    end

    def signature
      compute_signature(url.host, url.path, params)
    end

    protected

    def params
      @params ||= begin
        raw_params = CGI.parse(query || '')
        Hash[raw_params.map { |k,v| v.size == 1 ? [k, v[0]] : [k, v] }]
      end
    end

    def query
      url.query
    end

    def compute_signature(host, path, params)
      keys = params.keys.sort
      query_string = keys.map { |k| "#{CGI.escape(k)}=#{CGI.escape(params[k])}" }.join
      base_string = "#{CGI.escape(host)}&#{CGI.escape(path)}&#{CGI.escape(query_string)}"

      return Digest::HMAC.hexdigest(base_string, key, hash_method)
    end

    def signed?
      params.has_key?('signature')
    end


  end
end
