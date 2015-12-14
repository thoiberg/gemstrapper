require 'fileutils'

module Gemstrapper
	extend self

	def init(options)

		# Getting a list of folders to create based on folder structure within lib/templates
		templates_directory = File.expand_path('gemstrapper/templates', File.dirname(__FILE__))
		directories = Dir.chdir(templates_directory) do 
			Dir.glob('**/*').select {|f| File.directory? f}
		end
		
		directories.each {|d| Dir.mkdir(d.gsub('gem', options[:project_name]))}
	end
end