# UrlSign
[![Build Status](https://travis-ci.org/ushu/url_signer.svg?branch=master)](https://travis-ci.org/ushu/url_signer)
[![Code Climate](https://codeclimate.com/github/ushu/url_signer/badges/gpa.svg)](https://codeclimate.com/github/ushu/url_signer)

Quickly generate and verify signed urls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'url_signer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install url_signer

## Usage

### URL signing

To convert a URL into a signed url, pass it to `UrlSigner.sign`, passing it either a string of an instance of `URI`.

```ruby
# generate a new URI instance with `signature` param populated
signed_url = UrlSigner.sign('http://google.fr?q=test', key='mykey')
```

the returned value `signed_url` is an instance of `URI`.

### URL verification

Given a signed URL, you can check its authenticity by calling `UrlSigner.valid?` on it:

```ruby
# verify url validity for a given URI instance
UrlSigner.valid?(signed_url) # => true
```

### helper methods

The gem adds helper methods to <tt>String</tt> and <tt>URI</tt> classes:

```ruby
# to generate a signed uri directly form a string
signed_url = 'http://google.fr'.to_signed_uri(key: 'test')

# or if we have a URI insance already
url = URI.parse('http://google.fr')
signed_url = url.signed(key: 'test')

# finally to check for signature authenticity
signed_url.signature_valid?(key: 'test')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/url_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
