#!/usr/bin/ruby
require './magicdb.rb'

db = SQLite3::Database.new "wine.db"
db.results_as_hash = true

old = db.wines_tmp

old.country_names.uniq.each do |name|
	db.countries.insert name: name
end


=begin
	db.wines.add 
		id: row["id"]
		name: row["name"]
		vintage: row["vintage"]
		price: row["price"]
		comment: row["comment"]
		drunk_date: row["drunk_date"]
		purchase_date: row["purchase_date"]
		rating: row["rating"]
=end

