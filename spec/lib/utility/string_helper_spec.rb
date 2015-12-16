require 'gemstrapper/utility/string_helpers'

describe Gemstrapper::Utility::StringHelpers do
	include Gemstrapper::Utility::StringHelpers

	describe '#module_name_for' do
		it 'converts a hypenated string a module name' do
			expect(module_name_for('test-gem')).to eq('TestGem')
		end

		it 'converts underscored string into a module name' do 
			expect(module_name_for('test_gem')).to eq('TestGem')
		end
	end
end