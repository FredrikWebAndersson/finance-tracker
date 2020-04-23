# README

This is the finance tracker app from the Ruby on Rails Dev course. 

# Setup Homepage 
  run $ rails generate controller welcome index
  >sets a new "get" route => change to "root"
  >create a welcome_controller.rb and define the index action, welcome#index
  >create a view welcome folder and index.html.erb 

# Install Devise gem
  add gem 'devise' => Gemfile 
  run $ bundle install 
  run $ rails generate devise:install
  >Demands a few basic setups, for ex a root route, flash messages and 
    $ rails g devise:views 
  >setup the basic devise views for Users 
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
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


