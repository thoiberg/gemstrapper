begin
	## doing this to avoid execution issue when not supplying values
	require_relative '../../bin/gemstrapper'
rescue NoMethodError

end

describe OptionsParser do
	it 'raises an error if executed without a subcommand' do
		expect { OptionsParser.parse }.to raise_error(ArgumentError)
	end

	context '#init' do
		it 'raises an error if the project_name is not specified' do
			expect { OptionsParser.parse['init']}.to raise_error(ArgumentError)
		end
	end
	
end
