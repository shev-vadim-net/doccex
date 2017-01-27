class Doccex::PageElements::Footer < String
  def initialize(context, xml_string) # unlike other page elements, footers are contained in a separate file
    rels = context.instance_variable_get(:@rels)
    locals = { :rid => rels.next_id(:footer) }
    File.open(Rails.application.root.join('tmp/docx/word/footer1.xml'), 'w') {|file| file.write(xml_string)}
    super context.render(:partial => 'doccex/footer', :formats => [:xml], :locals => locals)
  end
end
