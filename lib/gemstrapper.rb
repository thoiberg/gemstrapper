require 'erb'
require 'fileutils'

require 'gemstrapper/utility/string_helpers'

##
# Top level module for the app.
module Gemstrapper
	include Utility::StringHelpers

	extend self

	##
	# Initialises a gem folder structure based on the project name passed in from the command
	# line and populates it with command files and configuration
	# @param [Hash] options The options passed in from the command line execution
	# @return [void]
	def init(options)
		@options = options

		new_files = []

		@options[:module_name] = module_name_for(@options[:project_name])
		# Getting a list of folders to create based on folder structure within lib/templates
		templates_directory = File.expand_path('gemstrapper/templates', File.dirname(__FILE__))

		files = Dir.chdir(templates_directory) do
			Dir.glob('**/*.erb')
		end

		files.each do |file|
			## creates directories
			# converting project name placeholder to actual project name and stripping off erb extension
			new_file_path = file.gsub('project_name', @options[:project_name]).gsub('.erb', '')
			directory = File.dirname(new_file_path)

			unless File.exist? directory
				FileUtils.mkdir_p directory
			end

			data = process_template(File.join(templates_directory, file), options)
			File.write(new_file_path, data)
			new_files << new_file_path
		end

		#reporting
		new_files.each do |nf|
			puts "#{nf} created"
		end
	end

	##
	# Reads an ERB file and populates the templated data from info in the
	# current execution scope
	# @param [String] file_path The absolute path of the ERB file
	# @param [Hash] options A Hash of options passed in from command line
	#     and generated dynamically. Is part of the execution scope so can be
	#     used as part of the ERB template
	# @return [String] the data from the ERB file filled out with data
	def process_template(file_path, options)
		template_data = File.read(file_path)

		ERB.new(template_data).result binding
	end
end