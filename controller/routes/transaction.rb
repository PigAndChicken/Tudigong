module Tudigong

    class Api < Roda

        route('transaction') do |routing|
            routing.on String do |t_id| 
                
                routing.get do
                    Transaction.find(t_id).to_json
                    rescue StandardError
                        routing.halt 404, { message: 'Document not found' }.to_json
                end
            end
            
            routing.post do
                new_data = JSON.parse(routing.body.read)
                new_tra = Transaction.new(new_data)

                if new_tra.save
                    response.status = 201
                    { message: "Transaction maked", id: new_tra.id }.to_json
                else
                    routing.halt 400, { message: 'Count not make transaction'}.to_json
                end
            end
        end

        route('transactions') do |routing|
            routing.get do
                output =  { transaction_ids: Transaction.all}
                JSON.pretty_generate(output)
            end
        end
    end

end