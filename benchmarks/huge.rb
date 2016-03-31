require_relative './runner'
require 'yaml'

Country = Struct.new(:code, :name, :population, :north, :south, :east, :west, :capital, :continent_name)
data = YAML.load_file('benchmarks/data/countries.yml')['countries']['country'] * 100
@countries = data.map{ |c| Country.new(*c.values) }

builder_tilt = Tilt.new('benchmarks/templates/large.builder')
ox_tilt = Tilt.new('benchmarks/templates/large.ox')

# Output is 11M

Benchmark.ips do |x|
  x.config(time: 60, warmup: 10)

  x.report('builder') do
    builder_tilt.render(Object.new, { countries: @countries })
  end

  x.report('ox') do
    ox_tilt.render(Object.new, { countries: @countries })
  end

  x.compare!
end
