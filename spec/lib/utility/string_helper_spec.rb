require 'gemstrapper/utility/string_helpers'

describe Gemstrapper::Utility::StringHelpers do
	include Gemstrapper::Utility::StringHelpers

	describe '#module_name_for' do
		it 'converts a hyphenated string a module name' do
			expect(module_name_for('test-gem')).to eq('TestGem')
		end

		it 'converts underscored string into a module name' do 
			expect(module_name_for('test_gem')).to eq('TestGem')
		end
	end

    describe '#executable_name_for' do
        it 'converts a hyphenated string into an underscored one' do
            expect(executable_name_for('test-gem')).to eq('test_gem')
        end
    end
end