module Gemstrapper
##
# Module for generic utitlity methods that can be reused throughout the code
module Utility
    ##
    # Mix-in with additional methods for working with Strings
	module StringHelpers
        ##
        # Converts a given string into a valid Ruby module name
        # @param [String] string The string to convert
        # @return [String] The given string converted into valid Ruby syntax for constants
		def module_name_for(string)
			string.split(/[-,_]/).map {|w| w.capitalize}.join('')
		end
	end
end
end