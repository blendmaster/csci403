#!/usr/bin/ruby
require './magicdb.rb'

db = SQLite3::Database.new "wine.db"
db.results_as_hash = true

old = db.wines_tmp

# seed countries
db.countries.insert name: old.country_names.uniq

# seed regions
regions = old.select([:region_name, :country_name], not_null: :region_name).map do |name, country|
	{name: name, country_id: db.countries.id(:name, country)}
end
regions.uniq! {|r| r[:name]} # remove duplicate names
db.regions.insert regions 

# seed grapes
db.grapes.insert({
	name: old.grape_names.map{|names| names.split ","}.flatten.map(&:strip).uniq
})

# seed wineries
db.wineries.insert name: old.winery_names.uniq

#seed vinyards
vinyards = old.select([:region_name, :vinyard_name, :winery_name], not_null: :vinyard_name)
vinyards.map! do |region,vinyard,winery|
	{name: vinyard, region_id: db.regions.id(:name, region), winery_id: db.wineries.id(:name, winery)}
end
vinyards.uniq!{|v| v[:name]}
db.vinyards.insert vinyards

# seed grapes_vinyards
grapes_vinyards = old.select([:vinyard_name, :grape_name], not_null: [:vinyard_name, :grape_name])
grapes_vinyards.map! do |vinyard,grape|
	{vinyard_id: db.vinyards.id(:name, vinyard), grape_id: db.grapes.id(:name, grape)} 
end
grapes_vinyards.uniq!
db.grapes_vinyards.insert grapes_vinyards

# seed wines
db.wines.insert({
	id: old.ids,
	name: old.names,
	vintage: old.vintages,
	price: old.prices,
	comment: old.comments,
	drunk_date: old.drunk_dates,
	purchase_date: old.purchase_dates,
	rating: old.ratings,
	winery_id: old.winery_names.map{|name| db.wineries.id(:name, name)}
})

