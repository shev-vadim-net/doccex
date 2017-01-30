xml.w :p do
  xml.w :pPr do
    xml.w :jc, "w:val" => align
  end
  xml.w :r do
    xml.w :rPr do
      xml.w :noProof
    end
    xml.w :drawing do
      xml.wp :inline, "distT" => "0", "distB" => "0", "distL" => "0", "distR" => "0" do
        xml.wp :extent, "cx" => dimensions[:w], "cy" => dimensions[:h]
        xml.wp :effectExtent, "l" => "0", "t" => "0", "r" => "0", "b" => "0"
        xml.wp :docPr, "id" => index, "name" => "Picture #{index}"
        xml.a :graphic, "xmlns:a" => "http://schemas.openxmlformats.org/drawingml/2006/main" do
          xml.a :graphicData, "uri" => "http://schemas.openxmlformats.org/drawingml/2006/picture" do
            xml.pic :pic, "xmlns:pic" => "http://schemas.openxmlformats.org/drawingml/2006/picture" do
              xml.pic :nvPicPr do
                xml.pic :cNvPr, "id" => "0", "name" => "Picture #{index}"
                xml.pic :cNvPicPr, "preferRelativeResize" => "0"
              end
              xml.pic :blipFill do
                xml.a :blip, "r:embed" => rid
                xml.a :srcRect
                xml.a :stretch do
                  xml.a :fillRect
                end
              end
              xml.pic :spPr, "bwMode" => "auto" do
                xml.a :xfrm do
                  xml.a :off, "x" => "0", "y" => "0"
                  xml.a :ext, "cx" => dimensions[:w], "cy" => dimensions[:h]
                end
                xml.a :prstGeom, "prst" => "rect" do
                  xml.a :avLst
                end
                xml.a :ln
              end
            end
          end
        end
      end
    end
  end
  xml.w :r do
    xml.w :rPr do
      xml.w :rtl, "w:val" => "0"
    end
  end
end
