require 'gemstrapper'

describe Gemstrapper do
	let(:config) {{
		project_name: 'my-gem'
	}}

	describe '#init' do
		it 'creates a typical gem folder structure' do
			expect(Dir).to receive(:mkdir).with("#{config[:project_name]}").once
			expect(Dir).to receive(:mkdir).with("#{config[:project_name]}/lib").once
			
			Gemstrapper.init({project_name: 'my-gem'})
		end
	end
end