require 'sqlite3'

# let's get ruby magical
# and never write vanilla sql again
class SQLite3::Database
	# sqlite won't bind create table statements
	# oh well, back to string interpolation
	def create_table name, options = {}, &block
		execute "create table #{TableDefinition.new name,options, &block}"
	end
end

# idea adapted from ActiveRecord's TableDefinition
class TableDefinition
	def initialize name,options,&block
		@name = name
		@columns = Hash.new
	
		# add primary key as "id" by default
		options = {id: true, primary_key: "id"}.merge options

		if options[:id]
			@columns[options[:primary_key]] = "integer primary key" 
		end

		instance_eval &block # add the rest of the columns
	end

	def to_s
		"\"#{@name}\" (#{
			@columns.map do |name, type|
				"\"#{name}\" #{type}"
			end.join ", "
		})"
	end

	# oh ruby, you so fancy
	%w[text int datetime numeric].each do |type|
		define_method type do |name|
			@columns[name] = type
		end
	end

end
