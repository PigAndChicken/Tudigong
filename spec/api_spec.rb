require_relative './spec_helper.rb'


DATA = YAML.safe_load File.read('./infrastructure/database/seeds/transaction_seeds.yml')

describe 'Test Tudigong Api' do
    include Rack::Test::Methods

    it 'should find root route' do
        get '/'
        _(last_response.status).must_equal 200
    end

    describe 'Test Api of handling data' do

        before do 
            Dir.glob('infrastructure/database/*.txt') do |file|
                FileUtils.rm(file)
            end
        end

        it 'HAPPY: should be able to post a transaction to database' do 
            req_header = { 'CONTENT_TYPE' => 'application/json' }
            post 'api/v0.1/transaction', DATA[1].to_json, req_header

            _(last_response.status).must_equal 201
        end

        it 'HAPPY: should be able to get all ids of transcation' do
            Tudigong::Transaction.new(DATA[0]).save
            Tudigong::Transaction.new(DATA[1]).save
            
            get "/api/v0.1/transactions"

            result = JSON.parse last_response.body
            _(last_response.status).must_equal 200
            _(result['transaction_ids'].count).must_equal 2 
        end

        it 'HAPPY: should be able to get details of a sigle transcation' do
            Tudigong::Transaction.new(DATA[0]).save
            
            id = Dir.glob( 'infrastructure/database/*.txt').first.split(%r{[/\.]})[2]
            
            get "/api/v0.1/transaction/#{id}"

            result = JSON.parse last_response.body
            _(last_response.status).must_equal 200
            _(result['id']).must_equal id
        end

        it 'SAD: should be able to show error msg when wrong id' do
            get '/api/v0.1/transaction/wrong_id'

            _(last_response.status).must_equal 404
        end

    end
end
