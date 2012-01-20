# Project 4 -- CSCI403 -- Steven Ruppert

An application that creates and migrates data for a sqlite wine database. 

* magicdb.rb: an unnecessary clone of some of the funcationality of
ActiveRecord. So unnecessary that is depends on ActiveSupport's inflector
anyway. Still cool though.
* create_schema.rb: creates the schema for a wine database.
* migrate.rb: migrates wine data from a wines_tmp table to the newly
created schema.
