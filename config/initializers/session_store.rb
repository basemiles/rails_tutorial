# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails_tutorial_session',
  :secret      => 'e04bb3f6fe8c5c07839ad2615db68757e5086280bb70b6b11eef80815ed3264eb1992c65c5844581aba812ff2680b8d2bf2aef47d2377d8d859b58699146e385'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
