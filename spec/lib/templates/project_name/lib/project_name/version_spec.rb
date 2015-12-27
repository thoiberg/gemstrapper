require 'gemstrapper'

describe 'project_name.gemspec template' do
    let(:project_name) { 'my-gem' }
    let(:options) { {project_name: project_name}.update(Gemstrapper.default_options(project_name)) }
    let(:version_file) { File.join(Gemstrapper::TEMPLATES_DIRECTORY, 'project_name/lib/project_name/version.rb.erb') }

    it 'generates the content for the version.rb' do
        data = Gemstrapper.process_template(version_file, options)

        expect(data).to include('module MyGem')
        expect(data).to include(%Q{VERSION = '0.0.1' unless defined? VERSION})
        expect(data).to include('end')
    end
end