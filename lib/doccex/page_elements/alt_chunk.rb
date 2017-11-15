class Doccex::PageElements::AltChunk < String
  def initialize(context, html_string) # chunks are contained in a separate file
    rels = context.instance_variable_get(:@rels)
    locals = { :rid => rels.next_id(:alt_chunk) }
    File.open(Rails.application.root.join("#{rels.path_to_tmp}/docx/word/html_#{locals[:rid]}.html"), 'w') {|file| file.write(html_string)}
    super context.render(:partial => 'doccex/alt_chunk', :formats => [:xml], :locals => locals)
  end
end
