require 'roda' 
require 'json'
require 'base64'

module Tudigong

    class Api < Roda
        plugin :environments
        plugin :multi_route 
        plugin :halt

        require_relative './routes/transaction.rb'

        route do |routing|
            
            routing.root do
                {message: "Tudigong API is running"}.to_json
            end

            routing.on 'api' do
                routing.on 'v0.1' do
                    routing.multi_route
                end
            end
        end

    end
end