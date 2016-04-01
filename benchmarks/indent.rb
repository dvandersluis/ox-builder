require_relative './runner'
require 'yaml'

Country = Struct.new(:code, :name, :population, :north, :south, :east, :west, :capital, :continent_name)
data = YAML.load_file('benchmarks/data/countries.yml')['countries']['country']
@countries = data.map{ |c| Country.new(*c.values) }

doc = Ox::Builder.build do
  instruct!

  countries do
    @countries.each do |country|
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
end

Benchmark.ips do |x|
  x.config(time: 20, warmup: 10)

  x.report('indent(200)') do
    doc.to_xml(indent: 200)
  end

  x.report('indent(10)') do
    doc.to_xml(indent: 10)
  end

  x.report('indent(2)') do
    doc.to_xml(indent: 2)
  end

  x.report('indent(0)') do
    doc.to_xml(indent: 0)
  end

  x.compare!
end
