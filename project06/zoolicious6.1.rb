#!/usr/bin/env ruby

require 'active_record'
require 'logger'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :host => 'localhost',
  :username => 'root',
  :password => 'RoKiE57',
  :adapter => 'mysql2',
  :database => 'zoolicious'
)

class User < ActiveRecord::Base
end

puts "Listing #{User.count} users in the database sorted by last name:"
User.order('last_name ASC').each do |user|
	puts "#{user.first_name} #{user.last_name} (#{user.username})"
end
