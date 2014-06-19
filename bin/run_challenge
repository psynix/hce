#!/usr/bin/env ruby

$: << File.expand_path('../lib', __dir__)
require 'hooroo'

$<.each_with_index do |line, line_number|
  begin
    output_line = Hooroo::Parser.new(line)
    STDOUT.write "#{output_line}\n"
  rescue => e
    STDERR.write "[ERROR] Line #%2d: #{e.message}\n" % line_number
  end
end
