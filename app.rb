require 'bundler'
Bundler.require
#session = GoogleDrive::Session.from_config("config.json")

$:.unshift File.expand_path("./../lib", __FILE__)

require 'app/scrapper'
require 'db/thing'

CSV.read("thing.csv")

#Scrapper.new.perform
