require 'spec_helper'

describe "URI extension" do
  let(:url) { URI.parse('http://google.fr') }
  let(:signed_url) { UrlSigner.sign(url, key: 'toto') }

  describe "#signed" do
    it "returns a signed version of the URI" do
      expect(url.signed(key: 'toto')).to eq(signed_url)
    end
  end

  describe "#valid" do
    it "returns true if the current url is signed" do
      expect(signed_url.signature_valid?(key: 'toto')).to eq(true)
    end
  end

end # URI extension
