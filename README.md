# Train scraper

Highly scalable and reliable scraper architecture for train planning websites and APIs

## Instructions

```bash
bundle install
irb
```

```ruby
require './lib/scraper'

Scraper::Thetrainline.find('Munchen', 'Salzburg', DateTime.now)
```

Note: the HTML response is mocked, so the function call signature does not matter
