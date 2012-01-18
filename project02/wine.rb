require 'sqlite3'

db = SQLite3::Database.new("wine.db")

db.query("select * from wine") do |wines|
	wines.each do |wine|
		wines.columns.size.times do |i|
			printf "%s: %s\n", wines.columns[i], wine[i]
		end
		puts "\n"
	end
end

