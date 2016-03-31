require_relative './runner'

builder_tilt = Tilt.new('benchmarks/templates/small.builder')
ox_tilt = Tilt.new('benchmarks/templates/small.ox')

# Output is 167 bytes

Benchmark.ips do |x|
  x.config(time: 10, warmup: 5)

  x.report('builder') do
    builder_tilt.render
  end

  x.report('ox') do
    ox_tilt.render
  end

  x.compare!
end
