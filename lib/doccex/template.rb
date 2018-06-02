require 'erb'

class Doccex::Template < Doccex::Base
  def initialize(template, view_assigns)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template(template)
  end

  def create_template(template)
    src = Pathname(template).absolute? ? template : Rails.application.root.join("app", template)
    FileUtils.cp_r(src , Rails.application.root.join(path_to_tmp), verbose: true)
    temp = template.split("/")[-1]
    FileUtils.rm_r("#{path_to_tmp}/docx", verbose: true) if File.exists?("#{path_to_tmp}/docx")
    FileUtils.mv("#{path_to_tmp}/#{temp}","#{path_to_tmp}/docx", verbose: true)
    system "ls -al #{path_to_tmp}/docx"
  end

  def render_to_string
    source = Rails.application.root.join("#{path_to_tmp}/docx")
    interpolate_variables
    zip_package(source)
    read_zipfile
  end

  def interpolate_variables
    source = Rails.application.root.join("#{path_to_tmp}/docx/word/document.xml")
    template = ERB.new File.read(source)
    File.write(source, template.result(binding))
  end

end
