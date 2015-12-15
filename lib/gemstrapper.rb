require 'erb'
require 'fileutils'

module Gemstrapper
	extend self

	def init(options)

		# Getting a list of folders to create based on folder structure within lib/templates
		templates_directory = File.expand_path('gemstrapper/templates', File.dirname(__FILE__))

		files = Dir.chdir(templates_directory) do
			Dir.glob('**/*.erb')
		end

		files.each do |file|
			## creates directories
			new_file_path = file.gsub('project_name', options[:project_name])
			directory = File.dirname(new_file_path)

			unless File.exist? directory
				FileUtils.mkdir_p directory
			end

			data = process_template(File.join(templates_directory, file), binding)
			File.write(new_file_path.gsub('.erb', ''), data)
		end

	end

	def process_template(file_path, binding)
		template_data = File.read(file_path)

		ERB.new(template_data).result binding
	end
end