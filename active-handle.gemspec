File.expand_path('lib', __dir__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

require 'action_handle/version'

Gem::Specification.new do |spec|
  spec.name    = 'action-handle'
  spec.version = ActionHandle::VERSION
  spec.authors = ['rbviz']
  spec.email   = ['inbox@rbviz.com']

  spec.summary     = 'Backend agnostic resource handle'
  spec.description = 'Allows distributed handle/lock creation and managament'
  spec.homepage    = 'https://github.com/rbviz/action-handle'
  spec.license     = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.require_paths = %w[lib]

  spec.add_dependency 'connection_pool', '~> 2.2'
  spec.add_dependency 'redis', '~> 4.1'

  spec.add_development_dependency 'activesupport', '~> 6.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'fakeredis', '~> 0.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
