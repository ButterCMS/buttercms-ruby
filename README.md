# ButterCMS API Ruby Client

## Documentation

For a comprehensive list of examples, check out the [API documentation](https://buttercms.com/docs/api/).

## Setup

To setup your project, follow these steps:

1. Install using `gem install buttercms-ruby` or by adding to your `Gemfile`:

  ```ruby
  gem 'buttercms-ruby'
  ```

2. Set your API token.

  ```ruby
  require 'buttercms-ruby'

  ButterCMS::api_token = "YourToken"

  # Fetch content from test mode (eg. for your staging website)
  # ButterCMS::test_mode = true
  ```

## Pages

```ruby
params = {foo: 'bar'} # optional
pages = ButterCMS::Page.list('news', params)
page = ButterCMS::Page.get('news', 'hello-world', params)
```

## Content Fields

```ruby
ButterCMS::Content.fetch(['homepage_headline'])

# Localization
ButterCMS::Content.fetch(['homepage_headline'], locale: 'es')

# Test mode can be used to setup a staging website for previewing Content Fields or for testing content during local development. To fetch content from test mode add the following configuration:
ButterCMS::test_mode = true
```

## Blog Engine

```ruby
posts = ButterCMS::Post.all(page: 1, page_size: 10)
puts posts.first.title
puts posts.meta.next_page

posts = ButterCMS::Post.search("my favorite post", {page: 1, page_size: 10})
puts posts.first.title

post = ButterCMS::Post.find("post-slug")
puts post.title

author = ButterCMS::Author.find("author-slug")
puts author.first_name

category = ButterCMS::Category.find("category-slug")
puts category.name

tags = ButterCMS::Tag.all
p tags

rss_feed = ButterCMS::Feed.find(:rss)
puts rss_feed.data
```


## Fallback Data Store

This client supports automatic fallback to a data store when API requests fail. When a data store is set, on every successful API request the response is written to the data store. When a subsequent API request fails, the client attempts to fallback to the value in the data store. Currently, Redis and YAML Store are supported.

```ruby
# Use YAMLstore
ButterCMS::data_store = :yaml, "/File/Path/For/buttercms.store"

# Use Redis
ButterCMS::data_store = :redis, ENV['REDIS_URL']

# Set logger (optional)
ButterCMS::logger = MyLogger.new
```

### Other

View Ruby [Blog engine](https://buttercms.com/ruby-blog-engine/) and [Full CMS](https://buttercms.com/ruby-cms/) for other examples of using ButterCMS with Ruby.
