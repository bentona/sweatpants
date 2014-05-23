require './lib/sweatpants'

c = Sweatpants::Client.new()

puts c

(1...1000000000000).each do |x|
  x / x**x  
end