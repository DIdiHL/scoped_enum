require 'bundler/setup'
Bundler.setup

require 'scoped_enum'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/support/schema.rb'
require File.dirname(__FILE__) + '/support/models.rb'
require File.dirname(__FILE__) + '/support/factory_girl'
require File.dirname(__FILE__) + '/factories'
