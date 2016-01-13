require 'erb'
require 'fileutils'

require 'gemstrapper/utility/string_helpers'

# Top level module for the app.
module Gemstrapper
	include Utility::StringHelpers

	# The absolute path of the directory containing all the templates needed for a new gem
	TEMPLATES_DIRECTORY = File.expand_path('gemstrapper/templates', File.dirname(__FILE__))

	extend self

	# Initialises a gem folder structure based on the project name passed in from the command
	# line and populates it with command files and configuration
	# @param [Hash] options The options passed in from the command line execution
	# @return [Void]
	def init(options)
		options = default_options(options[:project_name]).update(options)

		new_files = []

		files = template_files_for_gem(options)

		files.each do |file|
			## creates directories
			# converting project name placeholder to actual project name and stripping off erb extension
			new_file_path = file.gsub('project_name', options[:project_name]).gsub('.erb', '')

			new_file_path.gsub!('project_file_name', options[:project_file_name])
			# converting executable_name placeholder for any executable file names into valid names for the gem
			new_file_path.gsub!('executable_name', options[:project_file_name])

			directory = File.dirname(new_file_path)

			unless File.exist? directory
				FileUtils.mkdir_p directory
			end

			data = process_template(File.join(TEMPLATES_DIRECTORY, file), options)
			File.write(new_file_path, data)
			new_files << new_file_path
		end

		## modifying executable files to be executable
		# TODO: Check windows compatibility with this feature
		exe_files = new_files.select {|f| f.include? 'bin/'}.each do |file|
			File.chmod(0755, file)
		end

		#reporting
		new_files.each do |nf|
			puts "#{nf} created"
		end
	end

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

	# default config options for the execution
	# @param [String] project_name the name of the project. Used to create the default
	#     module name
	# @return [Hash] the default options
	def default_options(project_name)
		{
			module_name: module_name_for(project_name),
			executable: false,
			project_file_name: filename_for(project_name)
		}
	end

	# returns a list of template files to be processed and created for the new gem
	# @param [Hash] options a list of the current execution options
	# @return [Array] a list of template files
	def template_files_for_gem(options)
		files = []

		Dir.chdir(TEMPLATES_DIRECTORY) do
			files += Dir.glob('project_name/lib/**/*.erb') # library files
			files << 'project_name/Gemfile.erb' # adding Gemfile
			files << 'project_name/project_name.gemspec.erb' # adding Gemspec

			if options[:executable]
				files += Dir.glob('project_name/bin/*.erb') # executable files
			end
		end

		files
	end

end