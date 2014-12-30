require 'url_signer/base'

module UrlSigner
  class Verifier < Base # :nodoc:

    def valid?
      return false unless signed?

      # extract signature from params
      remaining_params = params.dup
      provided_signature = remaining_params.delete('signature')

      # recompute the signature using the secret key
      recomputed_signature = compute_signature(url.host, url.path, remaining_params)

      safe_compare(provided_signature, recomputed_signature)
    end

    private

    def safe_compare(signature, other_signature)
      hash_method.digest(signature) == hash_method.digest(other_signature)
    end

  end
end
