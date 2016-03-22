#!/usr/bin/env ruby

require 'dotenv'
require 'aws-sdk'

Dotenv.load

file_name = ARGV.first || 'build.tar.gz'
stack = ARGV.last || ''

key = File.join(stack, File.basename(file_name))

puts "Uploading '#{Pathname.new(file_name)}'..."
puts "Using '#{ENV['AWS_ACCESS_KEY_ID']}' access key."

Aws.config = {
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => 'us-east-1'
}

s3 = Aws::S3::Client.new

resp = File.open(file_name, 'rb') do |file|
  s3.put_object(
    :bucket => 'heroku-buildpack-r',
    :key => key,
    :body => file,
    :acl => 'public-read'
  )
end

puts "Uploaded '#{key}' to S3 successfully. [#{resp.etag}]"
