require 'gemstrapper'

describe 'project_name.gemspec template' do
    let(:project_name) { 'my-gem' }
    let(:options) { {project_name: project_name}.update(Gemstrapper.default_options(project_name)) }
    let(:options_with_executable_set) { options.update(executable: true) }
    let(:gemspec_file) { File.join(Gemstrapper::TEMPLATES_DIRECTORY, 'project_name/project_name.gemspec.erb') }

    it 'sets the default gemspec configuration' do
        data = Gemstrapper.process_template(gemspec_file, options)

        # TODO: Write a custom RSpec matcher to perform whitespace agnostic matching
        expect(data).to include('Gem::Specification.new do |s|')
        expect(data).to include(%Q{s.name          = '#{options[:project_name]}'})
        expect(data).to include(%Q{s.version       = #{options[:module_name]}::VERSION})
        expect(data).to include(%Q{s.version       = #{options[:module_name]}::VERSION})
        expect(data).to include(%Q{s.license       = 'MIT'})
        expect(data).to include(%Q{s.platform      = 'Gem::Platform::RUBY'})
        expect(data).to include(%Q{s.summary       = "short summary here"})
        expect(data).to include(%Q{s.description   = "longer description here"})
        expect(data).to include(%Q{s.author        = 'user'})
        expect(data).to include(%Q{s.email         = 'user@example.com'})
        expect(data).to include(%Q{s.require_paths = ['lib']})
        expect(data).to include(%Q{s.files         = Dir['lib/**/*']})
        expect(data).to include(%Q{s.homepage      = 'home page here'})
    end

    it 'sets the bindir and executable options if the executable flag is set' do
        expect(options_with_executable_set).to include(executable: true)
        data = Gemstrapper.process_template(gemspec_file, options_with_executable_set)

        expect(data).to include(%Q{s.bindir        = 'bin'})
        expect(data).to include(%Q{s.executables   << 'my_gem'})
        expect(data).to include(%Q{s.files         += Dir['bin/*']})
    end

    it 'does not set executable specific options if the executable flag is not set' do
        expect(options).to include(executable: false)
        data = Gemstrapper.process_template(gemspec_file, options)

        expect(data).not_to include(%Q{s.bindir})
        expect(data).not_to include(%Q{s.executables})
        expect(data).not_to include(%Q{s.files         += Dir['bin/*']})
    end
end