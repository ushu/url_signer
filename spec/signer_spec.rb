require 'spec_helper'

module UrlSigner
  describe Signer do
    let(:url_string) { 'http://mysite.com/my/path?test=1&retest=2' }
    let(:url) { URI.parse(url_string) }
    let(:params) { CGI.parse(url.query) }

    let(:signer) { Signer.new(url, key: 'testkey') }

    describe "#sign:" do
      let(:signed_url) { signer.sign }
      let(:signed_params) { CGI.parse(signed_url.query) }

      it "returns a new url" do
        expect(signed_url).to be_a(URI)
        expect(signed_url).not_to be(url)
      end

      it "keeps all the incoming parameters" do
        signed_params.delete('signature')
        expect(signed_params).to eq(params)
      end

      it "adds a signature parameter" do
        expect(signed_params).to have_key('signature')
      end

      describe "signature param" do
        let(:signature_param) { signed_params['signature'][0] }

        it "contains the computed signature" do
          expect(signature_param).to eq(signer.signature)
        end

      end # signature param

    end # #sign

  end
end
