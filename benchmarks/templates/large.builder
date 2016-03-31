xml.instruct!

xml.countries do
  countries.each do |country|
    xml.country do
      xml.name { xml.cdata!(country.name) }
      xml.code { xml.cdata!(country.code) }
      xml.continent { xml.cdata!(country.continent_name) }
      xml.capital { xml.cdata!(country.capital.to_s) }
      xml.population country.population

      xml.boundaries do
        xml.north country.north
        xml.sourth country.south
        xml.east country.east
        xml.west country.west
      end
    end
  end
end
