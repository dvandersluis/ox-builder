$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ox/builder'

def load_xml(filename)
  File.read("spec/support/#{filename}.xml")
end
