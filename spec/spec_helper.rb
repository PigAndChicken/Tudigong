require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'yaml'

require_relative '../init.rb'

def app
    Tudigong::Api
end

