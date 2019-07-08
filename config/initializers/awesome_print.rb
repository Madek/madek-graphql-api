# https://github.com/awesome-print/awesome_print#setting-custom-default
require 'awesome_print'

AwesomePrint.defaults = { indent: -2 }

AwesomePrint.pry! unless Rails.env.production?
