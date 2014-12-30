require 'spec_helper'

module UrlSigner
  describe Signer do
    let(:url_string) { 'http://mysite.com/my/path?test=1&retest=2' }
    let(:url) { URI.parse(url_string) }
    let(:params) { CGI.parse(url.query) }

    let(:signer) { Signer.new(url, key: 'testkey') }

    describe "#signature:" do
      let(:url_with_other_params) { URI.parse('http://mysite.com/my/path?test=2&retest=2') }
      let(:url_with_other_domain) { URI.parse('http://myothersite.com/my/path?test=1&retest=2') }
      let(:url_with_other_path) { URI.parse('http://mysite.com/my/other/path?test=1&retest=2') }

      it "depends on the signing key" do
        other_signer = Signer.new(url, key: 'othertestkey')
        expect(signer.signature).not_to eq(other_signer.signature)
      end

      it "depends on the parameters" do
        other_signer = Signer.new(url_with_other_params, key: 'testkey')
        expect(signer.signature).not_to eq(other_signer.signature)
      end

      it "depends on the domain" do
        other_signer = Signer.new(url_with_other_domain, key: 'testkey')
        expect(signer.signature).not_to eq(other_signer.signature)
      end

      it "depends on the path" do
        other_signer = Signer.new(url_with_other_path, key: 'testkey')
        expect(signer.signature).not_to eq(other_signer.signature)
      end
    end

    describe "url parameter:" do

      context "when the url is given as a string," do
        let(:signer_from_string) { Signer.new(url_string, key: 'testkey') }

        it "builds a new signer" do
          expect { Signer.new(url_string, key: 'testkey') }.not_to raise_error
        end

        it "works as usual" do
          expect{ signer_from_string.sign }.not_to raise_error
        end

        it "is equivalent to the save Signer built from a URI instance" do
          expect(signer_from_string.sign).to eq(signer.sign)
        end

        it "raise if the URL can not be parsed" do
          expect{ Signer.new('not a good idea') }.to raise_error
        end

      end

      it "raise a descriptive message if an invalid type is passed" do
        expect{ Signer.new([ 'not a good idea' ]) }.to raise_error
      end

    end

    describe "#sign:" do
      let(:signed_url) { signer.sign }
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

      context "when an url has been signed," do
        let(:verification_signer) { Signer.new(signed_url, key: 'testkey') }

        it "can verify the url" do
          expect(verification_signer.valid?).to be(true)
        end

        context "when the signed url has been modified," do
          # will overload signed_url in this context
          let(:signed_url) {
            vanilla_url = signer.sign
            vanilla_url.query += '&toto=titi'
            vanilla_url
          }

          it "does not verify the url" do
            expect(verification_signer.valid?).to be(false)
          end

        end
      end

      context "when an url has not been signed," do
        it "does not verify the url" do
          expect(signer.valid?).to be(false)
        end
      end
    end

  end
end
