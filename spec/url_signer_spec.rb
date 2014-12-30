require 'spec_helper'

describe UrlSigner do
  let(:signer) { UrlSigner.new(key: 'testkey') }
  let(:url_string) { 'http://mysite.com/my/path?test=1&retest=2' }
  let(:url) { URI.parse(url_string) }
  let(:params) { CGI.parse(url.query) }

  describe "#signature_for_url:" do
    let(:other_signer) { UrlSigner.new(key: 'othertestkey') }
    let(:url_with_other_params) { URI.parse('http://mysite.com/my/path?test=2&retest=2') }
    let(:url_with_other_domain) { URI.parse('http://myothersite.com/my/path?test=1&retest=2') }
    let(:url_with_other_path) { URI.parse('http://mysite.com/my/other/path?test=1&retest=2') }

    it "depends on the signing key" do
      expect(signer.signature_for_url(url)).not_to eq(other_signer.signature_for_url(url))
    end

    it "depends on the parameters" do
      expect(signer.signature_for_url(url)).not_to eq(signer.signature_for_url(url_with_other_params))
    end

    it "depends on the domain" do
      expect(signer.signature_for_url(url)).not_to eq(signer.signature_for_url(url_with_other_domain))
    end

    it "depends on the path" do
      expect(signer.signature_for_url(url)).not_to eq(signer.signature_for_url(url_with_other_path))
    end
  end

  describe "#sign:" do
    let(:signed_url) { signer.sign(url) }
    let(:signed_params) { CGI.parse(signed_url.query) }

    it "returns a new url" do
      expect(signed_url).to be_a(URI)
      expect(signed_url).not_to be(url)
    end

    it "adds a signature parameter" do
      expect(signed_params).to have_key('signature')
    end

    it "keeps all the incoming parameters" do
      signed_params.delete('signature')
      expect(signed_params).to eq(params)
    end

    it "accepts string parameters" do
      expect{ signer.sign(url_string) }.not_to raise_error
      expect(signer.sign(url_string)).to eq(signer.sign(url))
    end

    it "raise a descriptive message if an invalid type is passed" do
      expect{ signer.sign([ 'not a good idea' ]) }.to raise_error
    end

    it "raise if the URL can not be parsed" do
      expect{ signer.sign('not a good idea') }.to raise_error
    end

    context "when an url has been signed," do

      it "can verify the url" do
        expect(signer.valid?(signed_url)).to be(true)
      end

      context "when the signed url has been modified," do

        let(:modified_url) {
          signed_url.dup.tap { |u| u.query += '&toto=titi' }
        }

        it "does not verify the url" do
          expect(signer.valid?(modified_url)).to be(false)
        end

      end
    end

    context "when an url has not been signed," do
      it "does not verify the url" do
        expect(signer.valid?(url)).not_to be(true)
      end
    end
  end

end
