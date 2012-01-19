#!/usr/bin/ruby
require './magicdb.rb'

db = SQLite3::Database.new( "wine.db" )

# clear existing tables
db.drop_tables :countries, :vinyards, :wineries, :grapes, :grapes_wines, :grapes_vinyards, :wines

db.create_table :countries do
	text :name, unique: true
end

db.create_table :vinyards do
	text :parcel_id, unique: true
	text :name
	text :region
	foreign_key_to :country
	foreign_key_to :winery
end

db.create_table :wineries do
	text :name
	int :tax_id, unique: true
end

db.create_table :grapes do
	text :name, unique: true
end

db.create_join_table :grapes, :wines

db.create_join_table :grapes, :vinyards

db.create_table :wines do
	text :sku, unique: true
	text :name
	text :vintage
	numeric :price
	text :comment
	int :rating
	date :drunk_date
	date :purchase_date

	foreign_key_to :winery
end


