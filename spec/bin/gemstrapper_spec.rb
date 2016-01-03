require 'open3'
require 'cli_test'

describe 'Gemstrapper CLI' do
    include CliTest

    let(:script_path) { File.expand_path('../../../bin/gemstrapper', __FILE__) }

    it 'displays the help message when the --help switch is used' do
        execute_script(script_path, args: '--help')

        expect(last_execution).to be_successful
        expect(last_execution.output).to include('Usage: gemstrapper [options] [subcommand [options]]')
    end

    it 'returns an error if a subcommand is not specified' do
        execute_script(script_path)

        expect(last_execution).not_to be_successful
        expect(last_execution.stdout).to eq("Invalid argument: Command should be: gemstrapper init <project_name>\n")
    end

    it 'returns a message if the subcommand is invalid' do
        execute_script(script_path, args: ['fake', 'my-gem'])

        expect(last_execution).not_to be_successful
        expect(last_execution.stdout).to eq("Invalid argument: Command should be: gemstrapper init <project_name>\n")
    end

    context 'init subcommand' do
        let(:working_directory) { File.expand_path('../../temp', __FILE__) }
        let(:project_name) { 'test-gem' }

        before(:each) do
            Dir.mkdir(working_directory) unless Dir.exists? working_directory
        end

        after(:each) do
            FileUtils.rm_rf working_directory
        end

        it 'creates the gem structure and files inside the current working directory' do
            Dir.chdir(working_directory) do
                execute_script(script_path, args: ['init', "#{project_name}"])
            end

            expect(last_execution).to be_successful
            expect(last_execution.output).to include("#{project_name}/Gemfile created")
            expect(last_execution.output).to include("#{project_name}/test-gem.gemspec created")
            expect(last_execution.output).to include("#{project_name}/lib/test-gem/version.rb created")
            expect(last_execution.output).to include("#{project_name}/lib/test_gem.rb created")

            expect(File.exists?("#{working_directory}/#{project_name}/Gemfile")).to be_truthy
            expect(File.exists?("#{working_directory}/#{project_name}/test-gem.gemspec")).to be_truthy
            expect(File.exists?("#{working_directory}/#{project_name}/lib/#{project_name}/version.rb")).to be_truthy
            expect(File.exists?("#{working_directory}/#{project_name}/lib/test_gem.rb")).to be_truthy
            expect(File.exists?("#{working_directory}/#{project_name}/bin/test_gem")).to be_falsey
        end

        it 'creates the executable files if the executable flag is set' do
            Dir.chdir(working_directory) do
                execute_script(script_path, args: ['init', "#{project_name}", '--executable'])
            end

            expect(last_execution).to be_successful
            expect(last_execution.output).to include("#{project_name}/bin/test_gem created")

            expect(File.exists? "#{working_directory}/test-gem/bin/test_gem").to be_truthy
            expect(File.executable? "#{working_directory}/test-gem/bin/test_gem").to be_truthy
        end

        it 'can work regardless of subcommand order' do
            Dir.chdir(working_directory) do
                execute_script(script_path, args: ['init', '-e', "#{project_name}"])
            end

            expect(last_execution).to be_successful
            expect(last_execution.output).to include("#{project_name}/bin/test_gem created")
        end
    end
    
end