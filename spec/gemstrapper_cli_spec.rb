require 'open3'

describe 'Gemstrapper CLI' do
    let(:script_path) { File.expand_path('../../bin/gemstrapper.rb', __FILE__) }

    def execute_gemstrapper(command)
        o, s = Open3.capture2e("bundle exec ruby #{script_path} #{command}")
        return o, s
    end

    it 'displays the help message when the --help switch is used' do
        output, status = execute_gemstrapper('--help')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: gemstrapper [options] [subcommand [options]]')
    end

    it 'returns an error if a subcommand is not specified' do
        output, status = execute_gemstrapper('')

        expect(status.exitstatus).to eq(1)
        expect(output).to include('Invalid argument. Command should be: init <gem_name> (ArgumentError)')
    end

    context 'init subcommand' do
        let(:working_directory) { File.expand_path('../temp', __FILE__) }

        before(:each) do
            Dir.mkdir(working_directory) unless Dir.exists? working_directory
        end

        after(:each) do
            FileUtils.rm_rf working_directory
        end

        it 'creates the gem structure and files inside the current working directory' do
            output, status = nil
            project_name = 'test-gem'

            Dir.chdir(working_directory) do
                output, status = execute_gemstrapper("init #{project_name}")
            end

            expect(status).to eq(0)
            expect(output).to include("#{project_name}/Gemfile created")
            expect(output).to include("#{project_name}/test-gem.gemspec created")
            expect(output).to include("#{project_name}/lib/test-gem/version.rb created")

            expect(Dir.exists?("#{working_directory}/test-gem")).to be_truthy
            expect(Dir.exists?("#{working_directory}/test-gem/lib")).to be_truthy
            expect(Dir.exists?("#{working_directory}/test-gem/lib/test-gem")).to be_truthy
        end
    end
    
end