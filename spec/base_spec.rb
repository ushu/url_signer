require 'spec_helper'

module UrlSigner
  describe Base do
    let(:url_string) { 'http://mysite.com/my/path?test=1&retest=2' }
    let(:url) { URI.parse(url_string) }
    let(:params) { CGI.parse(url.query) }

    let(:base) { Base.new(url, key: 'testkey') }

    describe "#signature:" do
      let(:url_with_other_params) { URI.parse('http://mysite.com/my/path?test=2&retest=2') }
      let(:url_with_other_domain) { URI.parse('http://myothersite.com/my/path?test=1&retest=2') }
      let(:url_with_other_path) { URI.parse('http://mysite.com/my/other/path?test=1&retest=2') }

      it "depends on the signing key" do
        other = Base.new(url, key: 'othertestkey')
        expect(other.signature).not_to eq(base.signature)
      end

      it "depends on the parameters" do
        other = Base.new(url_with_other_params, key: 'testkey')
        expect(other.signature).not_to eq(base.signature)
      end

      it "depends on the domain" do
        other = Base.new(url_with_other_domain, key: 'testkey')
        expect(other.signature).not_to eq(base.signature)
      end

      it "depends on the path" do
        other = Base.new(url_with_other_path, key: 'testkey')
        expect(other.signature).not_to eq(base.signature)
      end
    end # #signature

    describe "url parameter:" do

      context "when the url is given as a string," do
        let(:base_from_string) { Base.new(url_string, key: 'testkey') }

        it "builds a new signer" do
          expect { Base.new(url_string, key: 'testkey') }.not_to raise_error
        end

        it "works as usual" do
          expect{ base_from_string.signature }.not_to raise_error
        end

        it "is equivalent to the save Signer built from a URI instance" do
          expect(base_from_string.signature).to eq(base.signature)
        end

        it "raise if the URL can not be parsed" do
          expect{ Base.new('not a good idea') }.to raise_error
        end

      end

      it "raise a descriptive message if an invalid type is passed" do
        expect{ Signer.new([ 'not a good idea' ]) }.to raise_error
      end

    end # url parameter:

  end
end
