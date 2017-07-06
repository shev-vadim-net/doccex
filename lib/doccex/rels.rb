require 'builder'

class Doccex::Rels
  attr_accessor :relationships, :footerReference

  BASIC_RELATIONSHIPS = [ { :id => "rId1",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles",
                            :target => "styles.xml"},
                          { :id => "rId2",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings",
                            :target => "settings.xml"},
                          { :id => "rId3",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings",
                            :target => "webSettings.xml"},
                          { :id => "rId4",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable",
                            :target => "fontTable.xml"},
                          { :id => "rId5",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",
                            :target => "theme/theme1.xml"},
                          { :id => "rId6",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/font",
                            :target => "fonts/Oxygen-Regular.ttf"},
                          { :id => "rId7",
                            :type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/font",
                            :target => "fonts/Oxygen-Bold.ttf"} ]


  OTHER_RELATIONSHIPS = { :footer => {:type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer", :target => "footer1.xml"},
                          :image => {:type => "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"} }

  attr_accessor :path_prefix

  def initialize(path_prefix = nil)
    @path_prefix = path_prefix
    @relationships = BASIC_RELATIONSHIPS.dup
    @printer_index = 1
    @image_index = 0
  end

  def next_id(type, *args)
    new_id = "rId" + relationships.map{|r| r[:id]}.last.match(/\d+/)[0].next
    new_rel = OTHER_RELATIONSHIPS[type]
    if type == :footer
      @relationships << {:id => new_id, :type => new_rel[:type], :target => new_rel[:target]}
      @footerReference = new_id
    elsif type == :printer
      target = new_rel[:target].dup.gsub!(/INDEX/,@printer_index.to_s)
      @relationships << {:id => new_id, :type => new_rel[:type], :target => target}
      # copy_printerSettings
      @printer_index += 1
    elsif type == :image
      @image_index += 1
      target = Rails.root.join(args[0]).to_s.match(/media.*/)[0]
      @relationships << {:id => new_id, :type => new_rel[:type], :target => target}
    end
    new_id
  end

  def next_image_index
    @image_index
  end

  def copy_printerSettings
    system "cp #{Rails.application.root.join("#{path_to_tmp}/docx/word/printerSettings/printerSettings1.bin")} #{Rails.application.root.join("#{path_to_tmp}/docx/word/printerSettings/printerSettings#{@printer_index.to_s}.bin")}"
  end

  def render_to_string
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, :standalone => 'yes'
      xml.Relationships "xmlns" => "http://schemas.openxmlformats.org/package/2006/relationships" do
        @relationships.each do |rel|
          xml.Relationship "Id" => rel[:id], "Type" => rel[:type], "Target" => rel[:target]
        end
      end
  end

  def create_file
    File.open(Rails.application.root.join("#{path_to_tmp}/docx/word/_rels/document.xml.rels"),'w'){|f| f.write(render_to_string)}
  end

  def path_to_tmp
    path_prefix.nil? ? 'tmp' : "tmp/#{path_prefix}"
  end
end
