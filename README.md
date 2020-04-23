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

