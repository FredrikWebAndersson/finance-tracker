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

## Before Action 
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

## New function begin 
```ruby
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
```
# AJAX XHR request
add to form in views
```ruby
remote: true 
```
## Setup JavaScript response
in stocks controller search action, add the response as a js format 
```ruby
respond_to do |format|
          format.js { render partial: "users/result" }
```
add the partial as a js erb file 
_result.js.erb

now add this Javascript to the file: 
```javascript
document.querySelector("#results").innerHTML = "<%= j render "users/result.html" %>"
```

## Correct and handle the errors 
Just use the same function as for showing stocks and update the code with the same code, update flash message to a flash.now.
```ruby
respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search stocks"
          format.js { render partial: "users/result" }
        end
```

# Many-to-many Association Stocks/Users
Build user_stocks table, user_stocks_controller and user_socks Model
```bash
  $ rails g resource UserStock user:references stock:references
```
Set simple through association for Stock table 
```ruby
  has_many :user_stocks
  has_many :users, through: :user_stocks
  ```
same for User table
```ruby
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
```
run $ rails db:migrate 

# User stock table view, add stocks @ front-end

To use the user_stocks table to display the users stocks table 
check if ticker allready in the db : models/stock.rb
```ruby
 def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
```

update the user stocks controller and add create method 

```ruby
def create 
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{ stock.name } was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end
```

## Add restrictions for portfolio list 

Update User model to define restriction methods 
```ruby
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
  ```
In portfolio view, use these functions to either show add button or over limit/already tracking message.

# Add First and Last Name to User profile, sign up and edit 

Update sign up and edit forms in views
> use devise code in application controller to handle the new fields and inputs
> also remeber to generate a new migration file to add first and last name fields in user table 
 
```ruby
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
```

# Friend Relationship, users
## Self referential association

run $ rails g model Friendship

in migration file :
```ruby 
t.references :user, null: false, foreign_key: true 
t.references :friend, references: :users, foreign_key: { to_table: :users }
```

Update Friendship Model : 
```ruby
  belongs_to :user
  belongs_to :friend, class_name: "User"
```

Update User Moded for association : 
```ruby
  has_many :friendships
  has_many :friends, through: :friendships
```

run $ rails db:migrate

