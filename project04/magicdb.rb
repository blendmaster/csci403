require 'sqlite3'
require 'active_support/inflector' #pluralize and singularize

# let's get ruby magical
# and never write vanilla sql again
class SQLite3::Database
	# sqlite won't bind create table statements
	# oh well, back to string interpolation
	def create_table name, options = {}, &block
		puts "create table #{TableDefinition.new name,options, &block}"
	end

	def create_join_table *tables
		create_table (tables.map {|t| t.to_s.pluralize}.join("_")), id: false do |t|
			tables.each do |table|
				t.foreign_key_to table.to_s.singularize
			end
		end
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
	
		# add the columns in a block

		if block.arity > 0 # assume they want to keep their scope
			yield self
		else
			instance_eval &block # sugar without keeping scope
		end
	end
	
	# oh ruby, you so fancy
	%w[text int date datetime numeric].each do |type|
		define_method type do |name, options ={}|
			@columns[name] = "#{type} #{"unique" if options[:unique]}"
		end
	end

	def foreign_key_to name
		@columns["#{name}_id"] = "integer"
	end

	def to_s
		"\"#{@name}\" (#{
			@columns.map do |name, type|
				"\"#{name}\" #{type}"
			end.join ", "
		})".squeeze
	end


end
