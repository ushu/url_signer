# UrlSigner
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

*Note*: There are rdoc-formatted comments on the most useful methods, so running `rdoc` in the shell will give you
insights on the available options.
[Rubygems](https://rubygems.org/) also generate a HTML version of it [here](http://www.rubydoc.info/gems/url_signer).

### URL signing

To convert a URL into a signed url, pass it to `UrlSigner.sign`, passing it either a string of an instance of `URI`.

```ruby
# generate a new URI instance with `signature` param populated
signed_url = UrlSigner.sign('http://google.fr?q=test', key: 'mykey')
```

the returned value `signed_url` is an instance of `URI`.

### URL verification

Given a signed URL, you can check its authenticity by calling `UrlSigner.valid?` on it:

```ruby
# verify url validity for a given URI instance
UrlSigner.valid?(signed_url, key: 'mykey') # => true
```

### Helper methods on URI

The gem adds the `signed` helper method to <tt>URI</tt>, that returns a new signed version of the url:

```ruby
url = URI.parse('http://google.fr')
signed_url = url.signed(key: 'test')
```

## Rails integration

When using `Rails`, a set of helpers are added to `ActionController::Base`:

```ruby

class MyController < ActionController::Base
  # Will trigger the check on the request url
  before_action :verify_signature!, only: secure_action

  def get_signed_url
    @signed_url = sign_url(my_controller_secure_action_url)
    # Template will link to @signed_url
  end

  def secure_action
    # This method is only accessible with a signed url
  end
end

```

Note that the `sign_url` helper can also be used as a view helper:

```erb
<%= link_to 'Super secure action', sign_url(my_controller_secure_action_url) %>
```

The key and hash method used in `sign_url` and `verify_signature!` are provided through `Rails.configuration.url_signer`, which default to:

```ruby
# defaults values:
Rails.configuration.url_signer.key = ENV['URL_SIGNING_KEY']
Rails.configuration.url_signer.hash_method = Digest::SHA1
```

Note that provided env `URL_SIGNING_KEY` environment variable is usually enough to get a working URL signing environment.

## TODO

 [ ] Add an option to choose the param name: it is currently set to `signature`
 [ ] Allow to customize the signing process by selecting with parts of the URL to include (for eg. allow to sign only considering path and not domain etc.)
 [ ] Write tests for the Rails integration
 [ ] Improve docs

## Contributing

1. Fork it ( https://github.com/[my-github-username]/url_sign/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
