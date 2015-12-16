module Gemstrapper
module Utility
	module StringHelpers
		def module_name_for(project_name)
			project_name.split(/[-,_]/).map {|w| w.capitalize}.join('')
		end
	end
end
end