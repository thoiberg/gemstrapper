require 'gemstrapper'

describe 'Gemfile template' do
    let(:project_name) { 'my-gem' }
    let(:options) { {project_name: project_name}.update(Gemstrapper.default_options(project_name)) }
    let(:gemfile_file) { File.join(Gemstrapper::TEMPLATES_DIRECTORY, 'project_name/Gemfile.erb') }

    it 'generates the Gemfile with default options' do
    data = Gemstrapper.process_template(gemfile_file, options)

    expect(data).to include(%Q{source "https://rubygems.org"})
    expect(data).to include(%Q{gemspec})
    end

end