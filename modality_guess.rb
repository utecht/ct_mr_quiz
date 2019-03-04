#!/usr/bin/env ruby

require 'dicom'
require 'base64'
require 'sinatra'
include DICOM

set :bind, '0.0.0.0'
abort("Pass path to dicom images as argument") unless ARGV.count == 1
dicom_dir = ARGV[0]
dicom_dir << '/' unless dicom_dir[-1] == '/'

def random_crawl(cur_dir)
  f = Dir["#{cur_dir}*"].sample
  puts f
  return f unless File.directory?(f)
  f << '/'
  random_crawl(f)
end

get '/' do
  dcm = DObject.read(random_crawl(dicom_dir))
  redirect '/' unless dcm.read?
  @modality = dcm.modality.value
  image_blob = dcm.image.normalize.to_blob { self.format = "jpeg" }
  data_uri = Base64.encode64(image_blob).gsub(/\n/, "")
  @image_tag = '<img alt="preview" src="data:image/jpeg;base64,%s">' % data_uri
  erb :image
end
