module Gemstrapper
# Module for generic utitlity methods that can be reused throughout the code
module Utility
    # Mix-in with additional methods for working with Strings
	module StringHelpers
        
        # Converts a given string into a valid Ruby module name
        # @param [String] string The string to convert
        # @return [String] The given string converted into valid Ruby syntax for constants
		def module_name_for(string)
			string.split(/[-,_]/).map {|w| w.capitalize}.join('')
		end

        
        # Converts a given string into a string that follow Ruby conventions for file names
        # @param [String] string the string to convert
        # @return [String] The given string converted into a file name
        def filename_for(string)
            string.gsub('-', '_')
        end
	end
end
end