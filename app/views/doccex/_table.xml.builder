xml.w :tbl do
  xml.w :tblPr do
    xml.w :tblStyle, "w:val" => style
    xml.w :tblW, "w:w" =>"0", "w:type" =>"auto"
    xml.w :tblLook, "w:val" =>"04A0", "w:firstRow" =>"1", "w:lastRow" =>"0", "w:firstColumn" =>"1", "w:lastColumn" =>"0", "w:noHBand" =>"0", "w:noVBand" =>"1"
    xml.w :tblBorders do
      xml.w :top, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
      xml.w :left, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
      xml.w :bottom, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
      xml.w :right, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
      xml.w :insideH, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
      xml.w :insideV, "w:color" => "000000", "w:space" => "0", "w:sz" => "8", "w:val" => "none"
    end
  end
  xml.w :tblGrid do
    cols.each do |col|
      xml.w :gridCol, "w:w" => col[:twips].to_s
    end
  end

  xml << rows
end
