#!/usr/bin/env ruby
# encoding: UTF-8

require "yaml"
require "fileutils"
require_relative "lib/clean"

fi = Clean.new('~/.clean')
fi.parse