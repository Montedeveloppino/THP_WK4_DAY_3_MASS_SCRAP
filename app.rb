require 'bundler'
Bundler.require
#session = GoogleDrive::Session.from_config("config.json")

$:.unshift File.expand_path("./../lib", __FILE__)

require 'views/index'
require 'app/scrapper'
require 'app/email_sender'
require 'views/done'
require 'csv'

CSV.read("things.csv")

Scrapper.new.perform
