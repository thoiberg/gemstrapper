require 'gemstrapper'

describe Gemstrapper do
	let(:options) {{
		project_name: 'my-gem',
		module_name: 'MyGem'
	}}

	describe '#init' do
		before(:each) do
			expect(STDOUT).to receive(:puts).at_least(:once)
		end

		it 'creates a typical gem folder structure' do
			expect(File).to receive(:write).at_least(:once)

			expect(FileUtils).to receive(:mkdir_p).with("#{options[:project_name]}").at_least(:once)
			expect(FileUtils).to receive(:mkdir_p).with("#{options[:project_name]}/lib/#{options[:project_name]}").once

			
			Gemstrapper.init(options)
		end

		it 'creates files from erb templates' do
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)

			expect(File).to receive(:write).with("#{options[:project_name]}/lib/#{options[:project_name]}/version.rb", anything).once
			expect(File).to receive(:write).with("#{options[:project_name]}/my-gem.gemspec", anything).once
			expect(File).to receive(:write).with("#{options[:project_name]}/Gemfile", anything).once


			Gemstrapper.init(options)

		end

		it 'does not process executable files if the executable flag is not set' do
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)
			expect(File).to receive(:write).at_least(:once)
			expect(Gemstrapper).to receive(:process_template).with('project_name/bin/my_gem', options).never

			Gemstrapper.init(options.update(executable: false))
		end

		it 'creates the executable files if the executable flag is set' do
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)
			expect(File).to receive(:write).at_least(:once)
			expect(Gemstrapper).to receive(:process_template).with('project_name/bin/my_gem', options).once

			Gemstrapper.init(options.update(executable: true))
		end

	end

	describe '#process_template' do
		let(:template_path) { File.expand_path('../../../lib/gemstrapper/templates/project_name', __FILE__) }

		it 'generates the File data from the erb template' do
			expect(File).to receive(:read).with('test.erb').once.and_return('project_name: <%= options[:project_name] %>')

			data = Gemstrapper.process_template('test.erb', options)

			expect(data).to eq('project_name: my-gem')
		end

		context '#gem files' do
			it 'generates the content for the version.rb' do
				version_file = File.join(template_path, 'lib', 'project_name', 'version.rb.erb')
				data = Gemstrapper.process_template(version_file, options)

				expect(data).to include('module MyGem')
				expect(data).to include(%Q{VERSION = '0.0.1' unless defined? VERSION})
				expect(data).to include('end')
			end

			it 'generates the content for the gemspec' do
				gemspec_file = File.join(template_path, 'project_name.gemspec.erb')
				data = Gemstrapper.process_template(gemspec_file, options)


				# TODO: Write a custom RSpec matcher to perform whitespace agnostic matching
				expect(data).to include('Gem::Specification.new do |s|')
				expect(data).to include(%Q{s.name          = '#{options[:project_name]}'})
				expect(data).to include(%Q{s.version       = #{options[:module_name]}::VERSION})
				expect(data).to include(%Q{s.version       = #{options[:module_name]}::VERSION})
				expect(data).to include(%Q{s.license       = 'MIT'})
				expect(data).to include(%Q{s.summary       = "short summary here"})
				expect(data).to include(%Q{s.description   = "longer description here"})
				expect(data).to include(%Q{s.author        = 'user'})
				expect(data).to include(%Q{s.email         = 'user@example.com'})
				expect(data).to include(%Q{s.require_paths = ['lib']})
				expect(data).to include(%Q{s.files         = Dir['lib/**/*']})
				expect(data).to include(%Q{s.homepage      = 'home page here'})
			end

			it 'generates the Gemfile' do
				gemfile_file = File.join(template_path, 'Gemfile.erb')
				data = Gemstrapper.process_template(gemfile_file, options)

				expect(data).to include(%Q{source "https://rubygems.org"})
				expect(data).to include(%Q{gemspec})
			end
		end
	end

	describe '#default_options' do
		it 'returns a hash of default options' do
			default_options = Gemstrapper.default_options('my-gem')

			expect(default_options).to eq({module_name: 'MyGem',
										   executable: false})
		end
	end

	describe 'template_files_for_gem' do
		it 'returns the template files for the new gem' do
			files = Gemstrapper.template_files_for_gem(options.update(executable: false))

			expect(files.count).to eq(3)
			expect(files).to include('project_name/Gemfile.erb')
			expect(files).to include('project_name/project_name.gemspec.erb')
			expect(files).to include('project_name/lib/project_name/version.rb.erb')
		end
	end


end