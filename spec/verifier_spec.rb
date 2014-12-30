require 'spec_helper'

module UrlSigner
  describe Verifier do
    let(:url_string) { 'http://mysite.com/my/path?test=1&retest=2' }
    let(:url) { URI.parse(url_string) }
    let(:params) { CGI.parse(url.query) }

    let(:signer) { Signer.new(url, key: 'testkey') }

    describe "#valid?:" do
      let(:signed_url) { signer.sign }

      context "when an url has been signed," do
        let(:verifier) { Verifier.new(signed_url, key: 'testkey') }

        it "can verify the url" do
          expect(verifier.valid?).to be(true)
        end

        context "when the signed url has been modified," do
          # will overload signed_url in this context
          let(:signed_url) {
            vanilla_url = signer.sign
            vanilla_url.query += '&toto=titi'
            vanilla_url
          }

          it "does not verify the url" do
            expect(verifier.valid?).to be(false)
          end

        end
      end

      context "when an url has not been signed," do
        let(:verifier) { Verifier.new(url, key: 'testkey') }

        it "does not verify the url" do
          expect(verifier.valid?).to be(false)
        end
      end

    end # #valid?

  end
end

