xml.instruct!

xml.person id: 123 do
  xml.name { xml.cdata!('John Smith') }
  xml.age 37
  xml.nationality 'Canadian'
end
