instruct!

countries do
  countries.each do |country|
    country do
      name { cdata!(country.name) }
      code { cdata!(country.code) }
      continent { cdata!(country.continent_name) }
      capital { cdata!(country.capital) }
      population country.population

      boundaries do
        north country.north
        sourth country.south
        east country.east
        west country.west
      end
    end
  end
end
