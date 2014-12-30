require 'spec_helper'

describe "String extension" do
  let(:url_string) { 'http://google.fr' }
  let(:url) { URI.parse(url_string) }
  let(:signed_url) { UrlSigner.sign(url, key: 'toto') }

  describe "#to_signed_uri" do
    it "returns a signed version of the URI" do
      expect(url_string.to_signed_uri(key: 'toto')).to eq(signed_url)
    end
  end

end # URI extension
