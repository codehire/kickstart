# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kickstart_session',
  :secret      => '60da2ee8d149d3b2e09332079d12b54eabd04616bfd78a889f7d9d3643c1da926208e79d9984a83f997f15847a0abc10aacdfeb3cdf9d2264930305d491d8a10'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
