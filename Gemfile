source 'https://rubygems.org'

gem 'rails', '3.2.17'

#group :assets do
  gem 'sass-rails',   ' ~> 3.2.3'
  gem 'coffee-rails', ' ~> 3.2.1'
  gem 'uglifier',     ' >= 1.0.3'
  gem 'bootstrap-sass', '~> 3.1.1'
  #end

group :production do
  gem 'pg'
  gem 'dalli'
  gem 'exception_notification'
end

group :development, :test do
  gem 'jasmine-rails' # for JS unit testing
  gem 'capybara' # for JS integration testing
  gem 'poltergeist' # for PhantomJS-based testing with capybara
  gem 'sqlite3'
  gem 'letter_opener'
end

# For deployment
gem 'capistrano', '< 3.0.0'

# For LDAP support
gem 'ruby-ldap', :require => false

# For CAS support
gem 'rubycas-client', :git => 'https://github.com/rubycas/rubycas-client.git'

# Javascript niceities
gem 'ejs'
gem 'js-routes', :git => 'git://github.com/railsware/js-routes.git'

# Authorization layer
gem 'declarative_authorization', "~> 0.5.7"

# For MS Active Directory support
gem 'net-ldap', :git => 'git://github.com/ruby-ldap/ruby-net-ldap.git', :require => false
#gem 'active_directory', :git => 'git://github.com/richardun/active_directory.git', :require => false
gem 'active_directory', :git => 'git://github.com/cthielen/active_directory.git', :require => false

# For JSON templates
gem 'jbuilder'

# For scheduled tasks
gem 'whenever', :require => false

# For background processing
gem 'delayed_job_active_record'
gem 'daemons'

# For icon processing
gem 'paperclip', '~> 3.0'

# For memory usage checks
gem 'os', :require => false
