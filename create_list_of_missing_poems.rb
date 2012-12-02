# Collect empty files
# files = Dir.glob('poems/*').select { |x| !File.size?(x) }

# save list of empty files in missing poems.txt
# File.open('missing_poems.txt', 'w') { |f| f.write(files.join("\n"))}

# files = Dir.glob('poems/*').map { |x| File.size(x) }
# files.select { |file_size| file_size < 10 }
# .each { |small| puts small }

# Collect all files
files = Dir.glob('poems/*')
files.each do |f| 
  text = File.open(f, 'r').read
  if text[0] == "\n"
    text[0] = ''
    File.open(f, 'w') { |file| file.write(text) }
  end
end