ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path(File.dirname(__FILE__) + '/../app.rb')


