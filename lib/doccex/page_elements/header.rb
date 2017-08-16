class Doccex::PageElements::Header < String
  def initialize(context, xml_string) # unlike other page elements, headers are contained in a separate file
    rels = context.instance_variable_get(:@rels)
    locals = { :rid => rels.next_id(:header) }
    File.open(Rails.application.root.join("#{rels.path_to_tmp}/docx/word/header1.xml"), 'w') {|file| file.write(xml_string)}
    super context.render(:partial => 'doccex/header', :formats => [:xml], :locals => locals)
  end
end
