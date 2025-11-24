# Train scraper

Highly scalable and reliable scraper architecture for train planning websites and APIs
#### Brief overview of the system:
- Field: Represents a composable field (name, type, parsing function). A field will guarentee appropriate parsing, formatting, and validation of a resource.
- Validators and Formatters: Simple modules containing reusable methods. The methods are conventionally named after the types of fields a given scraper can define.
- Scraper: Represents a given scraper per a source. Each implemented scraper composes a list of fields, with each defining its name, type, and parsing function. 

## Instructions

```bash
$ bundle install
$ irb
```

```ruby
require './lib/scraper'

Scraper::Thetrainline.find('Munchen', 'Salzburg', DateTime.now)
```

Note: the HTML response is mocked, so the function call signature does not matter
