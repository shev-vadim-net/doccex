class Doccex::Base

  attr_accessor :path_prefix

  def path_to_tmp
    path_prefix.nil? ? 'tmp' : "tmp/#{path_prefix}"
  end

  def tmp_file
    Rails.application.root.join("#{path_to_tmp}/tmp_file.docx")
  end

  def zip_package(dir)
    $stderr.puts "cd #{dir}"
    FileUtils.cd(dir) do
      $stderr.puts "zip -qr #{tmp_file} . -x \*.DS_Store \*.git/\* \*.gitignore \*.gitkeep"
      result = system "zip -qr #{tmp_file} . -x \*.DS_Store \*.git/\* \*.gitignore \*.gitkeep"
      $stderr.puts "Error while zipping docx: #{$?}" unless result
    end
    cleanup(dir)
  end

  def read_zipfile
    string = File.read(tmp_file)
    cleanup(tmp_file)
    cleanup(path_to_tmp)
    string
  end

  def cleanup(*files)
    files.each do |f|
      FileUtils.send(File.directory?(File.new(f)) ? "rm_r" : "rm", f, verbose: true)
    end
  end
end
