#!/usr/bin/env ruby

require 'optparse'
require 'gemstrapper'

class OptionsParser

	def self.parse(args)
		subtext = %Q{
		Commonly used command are:
		   init :     creates a gem scaffolding in the current folder
		See 'gemstrapper COMMAND --help' for more information on a specific command.}

		options = {}
		global = OptionParser.new do |opts|
		  opts.banner = "Usage: gemstrapper [options] [subcommand [options]]"
		  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
		    options[:verbose] = v
		  end

		  opts.on_tail("-h", "--help", "Show this message") do
        	puts opts
        	exit
      	  end
      	  
		  opts.separator ""
		  opts.separator subtext


		end

		subcommands = { 
		  'init' => OptionParser.new do |opts|
		      opts.banner = "Usage: init <folder_name>"
		    end
		 }

		global.order!
		command = args.shift
		project_name = args.shift
		raise ArgumentError.new("Invalid argument. Command should be: init <gem_name>") unless command or project_name
		options.update(project_name: project_name)
		subcommands[command].order!

		return command, options
	end

end

command, options = OptionsParser.parse(ARGV)
Gemstrapper.send(command, options)


