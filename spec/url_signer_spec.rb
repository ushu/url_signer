require 'spec_helper'

describe UrlSigner do
  let(:url) { 'http://google.fr' }
  let(:fake_signer) { double(sign: true, valid?: true) }

  FORWARDED_METHOD = %i(sign valid?)
  FORWARDED_METHOD.each do |method|
    describe ".#{method}:" do

      it "builds a new signer" do
        expect(UrlSigner::Signer).to receive(:new).with(key: 'toto').and_return(fake_signer)
        UrlSigner.sign(url, key: 'toto')
      end

      it "calls ##{method} on the new signer" do
        allow(UrlSigner::Signer).to receive(:new).and_return(fake_signer)
        expect(fake_signer).to receive(method).with(url)

        # call method by name dynamically
        UrlSigner.send(method, url, key: 'toto')
      end

    end
  end

end
