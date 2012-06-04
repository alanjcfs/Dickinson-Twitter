def make_stanza lines # lines are arrays
  # ary = lines.split("\n")
  stanzas = []
  if lines.size % 4 == 0
    (lines.size / 4).times do |line|
      stanzas << lines[line*4...line*4+4].join("\n")
    end
  else (lines.size / 4 + 1).times do |line|
      stanzas << lines[line*4...line*4+4].join("\n")
    end
  end
  return stanzas
end

def tweet stanza, client
  begin
    client.update("#{ stanza }")
  rescue Twitter::Error::Forbidden => e
    puts "Rescued Twitter::Error::Forbiden: #{e}"
  end
end