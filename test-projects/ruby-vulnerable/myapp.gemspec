Gem::Specification.new do |s|
  s.name        = 'myapp'
  s.version     = '0.1.0'
  s.summary     = 'TD-04: Ruby gemspec with known vulnerable dependencies'
  s.authors     = ['QScanner QA']
  s.add_dependency 'rack', '2.1.4'
  s.add_dependency 'nokogiri', '1.10.9'
end
