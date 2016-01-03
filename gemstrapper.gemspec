require_relative 'lib/gemstrapper/version'

Gem::Specification.new do |s|
  s.name        = 'gemstrapper'
  s.version     = Gemstrapper::VERSION
  s.license    = 'MIT'
  s.summary     = "A gem to generate gem scaffolding"
  s.description = "Creates gem scaffolding, complete with Gemfile and README"
  s.author     = 'Tim Hoiberg'
  s.email       = 'tim.hoiberg@gmail.com'
  s.platform   = Gem::Platform::RUBY
  s.files = Dir['lib/**/*'] + Dir['bin/*']
  s.bindir      = 'bin'
  s.executables << 'gemstrapper'
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/thoiberg/gemstrapper'

end