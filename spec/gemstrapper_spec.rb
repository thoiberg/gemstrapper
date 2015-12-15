require 'gemstrapper'

describe Gemstrapper do
	let(:config) {{
		project_name: 'my-gem'
	}}

	describe '#init' do
		it 'creates a typical gem folder structure' do
			expect(File).to receive(:write).at_least(:once)

			expect(FileUtils).to receive(:mkdir_p).with("#{config[:project_name]}").once
			expect(FileUtils).to receive(:mkdir_p).with("#{config[:project_name]}/lib/#{config[:project_name]}").once

			
			Gemstrapper.init({project_name: 'my-gem'})
		end

		it 'creates files from erb templates' do
			expect(FileUtils).to receive(:mkdir_p).at_least(:once)

			expect(File).to receive(:write).with("#{config[:project_name]}/lib/#{config[:project_name]}/version.rb", anything).once
			expect(File).to receive(:write).with("#{config[:project_name]}/my-gem.gemspec", anything).once


			Gemstrapper.init({project_name: 'my-gem'})

		end

	end

	describe '#process_template' do
		it 'generates the File data from the erb template' do
			expect(File).to receive(:read).with('test.erb').once.and_return('project_name: <%= config[:project_name] %>')

			data = Gemstrapper.process_template('test.erb', binding)

			expect(data).to eq('project_name: my-gem')
		end
	end

end