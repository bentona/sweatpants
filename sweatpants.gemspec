$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'sweatpants'
  s.version       = '0.0.1'
  s.date          = '2014-04-01'
  s.summary       = "Wrapper for elasticsearch-ruby that bulks-up requests"
  s.description   = "Sponsored by Originate(http://originate.com)"
  s.authors       = ["Benton Anderson"]
  s.email         = 'benton.anderson@gmail.com'
  s.require_paths = ['lib']
  s.files         = Dir['{lib}/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md']
  s.test_files    = Dir['spec/**/*']
  s.homepage      = 'http://github.com/bentona/sweatpants'
  s.license       = 'MIT'
end
