class Doccex::Document < Doccex::Base
  def initialize(view_assigns, path_prefix = nil)
    @path_prefix = path_prefix
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template
  end

  def contents(string)
    File.open(Rails.application.root.join("#{path_to_tmp}/docx/word/document.xml"), 'w') {|file| file.write(string)}
  end

  def render_to_string
    source = Rails.application.root.join("#{path_to_tmp}/docx")
    zip_package(source)
    read_zipfile
  end

  def create_template
    # create dir, because without existing dir it doesn't copy into docx subfolder
    FileUtils.mkdir_p(Rails.application.root.join(path_to_tmp), verbose: true) unless @path_prefix.nil?
    FileUtils.cp_r(File.expand_path('../templates/docx',__FILE__), Rails.application.root.join(path_to_tmp), verbose: true)
    FileUtils.mkdir_p(Rails.application.root.join("#{path_to_tmp}/docx/word/media"), verbose: true)
    system "ls -alR #{path_to_tmp}/docx"
  end

end
