require 'gemstrapper'

describe Gemstrapper do
	let(:project_name) { 'my-gem' }
	let(:default_options) { Gemstrapper.default_options(project_name) }
	let(:options) { {project_name: project_name}.update(default_options) }
	let(:options_with_executable_set) { options.update(executable: true) }

	describe '#init' do
		before(:each) do
			expect(STDOUT).to receive(:puts).at_least(:once)
		end

		it 'creates a typical gem folder structure' do
			expect(File).to receive(:write).at_least(:once)

			expect(FileUtils).to receive(:mkdir_p).with("#{options[:project_name]}").at_least(:once)
			expect(FileUtils).to receive(:mkdir_p).with("#{options[:project_name]}/lib").at_least(:once)
			expect(FileUtils).to receive(:mkdir_p).with("#{options[:project_name]}/lib/#{options[:project_name]}").once

			
			Gemstrapper.init(options)
		end

		it 'creates files from erb templates' do
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)

			expect(File).to receive(:write).with("#{options[:project_name]}/lib/#{options[:project_file_name]}.rb", anything).once
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
			# stubbing out side effects
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)
			expect(File).to receive(:write).at_least(:once)

			allow(Gemstrapper).to receive(:template_files_for_gem) { ['project_name/bin/executable_name.erb'] }

			expect(File).to receive(:chmod).with(0755, anything).once

			executable_file = File.join(Gemstrapper::TEMPLATES_DIRECTORY, 'project_name/bin/executable_name.erb')
			expect(Gemstrapper).to receive(:process_template).with(executable_file, options).once

			Gemstrapper.init(options_with_executable_set)
		end

	end

	describe '#process_template' do
		let(:template_path) { File.expand_path('../../../lib/gemstrapper/templates/project_name', __FILE__) }

		it 'generates the File data from the erb template' do
			expect(File).to receive(:read).with('test.erb').once.and_return('project_name: <%= options[:project_name] %>')

			data = Gemstrapper.process_template('test.erb', options)

			expect(data).to eq('project_name: my-gem')
		end
	end

	describe '#default_options' do
		it 'returns a hash of default options' do
			default_options = Gemstrapper.default_options('my-gem')

			expect(default_options).to eq({module_name: 'MyGem',
										   executable: false,
										   project_file_name: 'my_gem'})
		end
	end

	describe 'template_files_for_gem' do
		it 'returns the template files for the new gem' do
			files = Gemstrapper.template_files_for_gem(options.update(executable: false))

			expect(files.count).to eq(4)
			expect(files).to include('project_name/Gemfile.erb')
			expect(files).to include('project_name/project_name.gemspec.erb')
			expect(files).to include('project_name/lib/project_name/version.rb.erb')
		end

		it 'returns any executable template files if the executable_flag is set' do
			files = Gemstrapper.template_files_for_gem(options_with_executable_set)

			expect(files.count).to eq(5)
			expect(files).to include('project_name/bin/executable_name.erb')
		end
	end


end