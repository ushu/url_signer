require 'spec_helper'

describe UrlSigner do
  let(:url) { 'http://google.fr' }
  let(:fake_signer) { double(sign: true, valid?: true) }

  describe ".sign:" do

    it "builds a new signer" do
      expect(UrlSigner::Signer).to receive(:new).with(key: 'toto').and_return(fake_signer)
      UrlSigner.sign(url, key: 'toto')
    end

    it "calls #sign on the new signer" do
      allow(UrlSigner::Signer).to receive(:new).and_return(fake_signer)
      expect(fake_signer).to receive(:sign).with(url)
      UrlSigner.sign(url, key: 'toto')
    end

  end

  describe ".valid?:" do

    it "builds a new signer" do
      expect(UrlSigner::Signer).to receive(:new).with(key: 'toto').and_return(fake_signer)
      UrlSigner.sign(url, key: 'toto')
    end

    it "calls #valid? on the new signer" do
      allow(UrlSigner::Signer).to receive(:new).and_return(fake_signer)
      expect(fake_signer).to receive(:sign).with(url)
      UrlSigner.sign(url, key: 'toto')
    end

  end

end
