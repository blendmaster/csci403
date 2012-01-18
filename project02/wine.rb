#!/usr/bin/ruby
require 'sqlite3'

db = SQLite3::Database.new("wine.db")

def create
	fields = Array.new
	puts "Enter a new wine into the database:"
	["name","price","purchase date","drunk date","rating","comment"].each do |field|
		print "#{field}: "
		fields.push gets.chomp
	end
	return fields
end

db.query("select * from wine") do |wines|
	wines.each do |wine|
		wines.columns.size.times do |i|
			printf "%s: %s\n", wines.columns[i], wine[i]
		end
		puts "\n"
	end
end

db.execute( "insert into wine(name,price,purchase_date, drunk_date,rating,comments) values( $0,$1,$2,$3,$4,$5)", create);
puts "New wine saved into the database."
