# UrlSign

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
>>> signed_url = UrlSigner.sign('http://google.fr?q=test', key='mykey')
```

the returned value `signed_url` is an instance of `URI`.

### URL verification

Given a signed URL, you can check its authenticity by calling `UrlSigner.valid?` on it:

```ruby
>>> UrlSigner.valid?(signed_url)
true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/url_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
