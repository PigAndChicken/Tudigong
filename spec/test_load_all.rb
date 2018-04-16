require 'base64'
require 'rbnacl/libsodium'
require 'rack/test'
require 'yaml'

require_relative '../init.rb'


include Rack::Test::Methods


def app
  Tudigong::Api
end

DATA = YAML.safe_load File.read('./infrastructure/database/seeds/transaction_seeds.yml')
STORE_DIR = './infrastructure/database/'
F_ID = 'tdKtO2LKVi'