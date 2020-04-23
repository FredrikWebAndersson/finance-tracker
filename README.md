# README

This is the finance tracker app from the Ruby on Rails Dev course. 

# Setup Homepage 
  ```bash
  $ rails generate controller welcome index
  ```
  >sets a new "get" route => change to "root"
  >create a welcome_controller.rb and define the index action, welcome#index
  >create a view welcome folder and index.html.erb 

# Install Devise gem
  add gem 'devise' => Gemfile 
  ```bash
  $ bundle install 
  $ rails generate devise:install
  ```
  >Demands a few basic setups, for ex a root route, flash messages and 
  ```bash
  $ rails g devise:views 
  ```
  >setup the basic devise views for Users 
  ```html
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
  ```
  >setup flash messages display in views

# Create Users 
  run $ rails generate devise User
  >sets up the model, and migration file
  check routes 
  run $ rails routes | grep users 
  run $ rails db:migrate

# Before Action 
  add a before action (for now in application controller)
  before_action :authenticate_user!

# Add Bootstrap 
```bash
  $ yarn add bootstrap@4.4 jquery popper.js
```
  >check the package.json file for import 

  => in config/webpack/environnment.js, add 
```javascript
  const webpack = require("webpack")
  environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  }))
```
  => app/javascript/packs/application.js, add 
```javascript
  import 'bootstrap'
```
  => app/assets/stylesheets/application.css, add
```javascript
  *= require bootstrap
```
  create cutom css file; app/assets/stylesheets/custom.css.scss, add 
```css
  @import 'bootstrap/dist/css/bootstrap';
```

## Add devise Boostrap templates 
add gem to Gemfile 
```bash 
gem 'devise-bootstrap-views', '~> 1.0'
```
>run $ bundle install
```bash 
rails generate devise:views:bootstrap_templates
```
if problem, Listen complaining: 
reference https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers

# Setup and use API key
## Use IEX ruby client 
ad to Gemfile: gem 'iex-ruby-client'

test in console:
```ruby
client = IEX::Api::Client.new(
  publishable_token: 'publishable_token',
  secret_token: 'secret_token',
  endpoint: 'https://sandbox.iexapis.com/v1'
)
```
reference :
https://github.com/dblock/iex-ruby-client

# Design and add Stock Model
generate model to set attributes ticker, name and last_price
$ rails g model Stock ticker:string name:string last_price:decimal

run $ rails db:migrate

## Set credentials in master.key 
run $ EDITOR="code --wait" rails credentials:edit

register API keys and save 

Update Stock Model, stock.rb file 
```ruby
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:api_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_api_key],
                                  endpoint: 'https://sandbox.iexapis.com/v1')
    client.price(ticker_symbol)
  end
  ```

# Add Font Awesome gem for icons 
add to Gemfile: gem "font-awesome-rails"

add to application.css
*= require font-awesome

now use types like : 
```ruby
fa_icon "search 4x"
``` 
or other 