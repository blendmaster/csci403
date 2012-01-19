#!/usr/bin/ruby
require './magicdb.rb'

db = SQLite3::Database.new "wine.db"
db.results_as_hash = true

old = db.wines_tmp

# seed countries
db.countries.insert name: old.country_names.uniq

# seed regions
regions = old.region_names.zip(old.country_names).map do |name, country|
	{name: name, country_id: db.countries.id(:name, country)}
end
regions.reject!{|r| r[:name].nil?} #remove nils
regions.uniq! {|r| r[:name]} # remove duplicate names
db.regions.insert regions 

# seed grapes
db.grapes.insert({
	name: old.grape_names.map{|names| names.split ","}.flatten.map(&:strip).uniq
})

# seed wineries
db.wineries.insert name: old.winery_names.uniq

#seed vinyards
vinyards = old.select(:region_name, :vinyard_name, :winery_name).map do |region,vinyard,winery|
	{name: vinyard, region_id: db.regions.id(:name, region), winery_id: db.wineries.id(:name, winery)}
end
vinyards.reject!{|v| v[:name].nil?}
vinyards.uniq!{|v| v[:name]}
db.vinyards.insert vinyards




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

