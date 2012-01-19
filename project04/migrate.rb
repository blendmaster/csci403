#!/usr/bin/ruby
require './magicdb.rb'

db = SQLite3::Database.new "wine.db"
db.results_as_hash = true

old = db.wines_tmp

# fill countries
db.countries.insert name: old.country_names.uniq

# fill grapes
db.grapes.insert name: old.grape_names.map{|names| names.split ","}.flatten.map(&:strip).uniq

# fill wineries
db.wineries.insert name: old.winery_names.uniq




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

