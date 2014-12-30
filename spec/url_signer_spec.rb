require 'spec_helper'

describe UrlSigner do
  let(:url) { 'http://google.fr' }
  let(:fake_signer) { double(sign: true, valid?: true) }

  FORWARDED_METHOD = {
    sign: ::UrlSigner::Signer,
    valid?: ::UrlSigner::Verifier
  }
  FORWARDED_METHOD.each do |method, klass|
    describe ".#{method}:" do

      it "builds a new #{klass} instance" do
        expect(klass).to receive(:new).with(url, key: 'toto').and_return(fake_signer)

        # call method by name dynamically
        UrlSigner.send(method, url, key: 'toto')
      end

      it "calls ##{method} on the new #{klass} instance" do
        allow(klass).to receive(:new).and_return(fake_signer)
        expect(fake_signer).to receive(method)

        # call method by name dynamically
        UrlSigner.send(method, url, key: 'toto')
      end

    end
  end

end
