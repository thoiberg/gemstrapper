require 'gemstrapper'

describe 'top level library file template' do
    let(:project_name) { 'my-gem' }
    let(:options) { {project_name: project_name}.update(Gemstrapper.default_options(project_name)) }
    let(:top_level_file) { File.join(Gemstrapper::TEMPLATES_DIRECTORY, 'project_name/lib/project_file_name.rb.erb') }

    it 'creates an empty top level module' do
        data = Gemstrapper.process_template(top_level_file, options)

        expect(data).to include(%Q{require '#{options[:project_name]}/version'})
        expect(data).to include(%Q{module #{options[:module_name]}})
        expect(data).to include(%Q{end})
    end

end