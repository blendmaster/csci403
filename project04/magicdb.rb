require 'sqlite3'
require 'active_support/inflector' #pluralize and singularize

# let's get ruby magical
# and never write vanilla sql again
class SQLite3::Database
	# sqlite won't bind create table statements
	# oh well, back to string interpolation
	def create_table name, options = {}, &block
		execute "create table #{TableDefinition.new name,options, &block}"
	end

	def create_join_table *tables
		create_table (tables.map {|t| t.to_s.pluralize}.join("_")), id: false do |t|
			tables.each do |table|
				t.foreign_key_to table.to_s.singularize
			end
		end
	end

	def drop_tables *tables
		tables.each do |table|
			execute "drop table if exists #{table}"
		end
	end

	alias_method :original_initialize, :initialize
	def initialize database
		original_initialize database
		# add {table name} accessors
		# using sqlite master table
		execute "select name from sqlite_master where type='table'" do |row|
			name = row[0]
			(class <<self; self;end).class_eval do # dynamically add methods to this instance
				define_method name do 
					Table.new self, name
				end
			end
		end
	end

end

class Table
	attr_accessor :name, :columns, :rows

	def initialize db, name
		@name = name
		@db = db

		db.results_as_hash = true
		@columns, *@rows = @db.execute2 "select * from #{@name}"

		# add column accessors by name
		@columns.each do |name|
			(class <<self; self;end).class_eval do # dynamically add methods to this instance
				define_method name.pluralize do
					@rows.map{|row| row[name]}
				end
			end
		end
	end

	def insert record
		fields = record.keys.join ', '
		values = record.values.map{|v| "\"#{v}\""}.join ', '
		@db.execute "insert into #{@name} (#{fields}) values (#{values})"
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
