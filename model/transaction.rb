require 'base64'
require 'json'
require 'rbnacl/libsodium'

module Tudigong

    class Transaction  
        STORE_DIR = './infrastructure/database/'

        def initialize(new_file) 
            @id  = new_file['id'] || new_id
            @user = new_file['user']
            @note = new_file['note']
            @item = new_file['item']
            @date = new_file['date']
            @money = new_file['money']
        end

        attr_reader :id, :date

        def save
            File.open(STORE_DIR + id + '.txt', 'w') do |file|
                file.write(to_json)
            end

            true
            rescue StandardError
            false
        end

        def self.all
            Dir.glob(STORE_DIR + '*.txt').map do |file|
                file.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
            end
        end

        def self.find(f_id)
            data =  JSON.parse File.read(STORE_DIR+ f_id + '.txt')
            Transaction.new(data)
        end

        def to_json
            {
                type: 'transaction',
                id: @id,
                user: @user,
                note: @note,
                item: @item,
                date: @date,
                money: @money
            }.to_json
        end
        

        private
        def new_id 
            timestamp = Time.now.to_f.to_s
            Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
        end

    end

end