#!/usr/bin/env ruby

require 'dicom'
include DICOM

dcm = DObject.read(ARGV[0])
puts dcm.summary
puts dcm.to_hash
puts dcm.to_hash['Series Instance UID']
