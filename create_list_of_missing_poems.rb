# Collect empty files
files = Dir.glob('poems/*').select { |x| !File.size?(x) }

# save list of empty files in missing poems.txt
File.open('missing_poems.txt', 'w') { |f| f.write(files.join("\n"))}

# files = Dir.glob('poems/*').map { |x| File.size(x) }
# files.select { |file_size| file_size < 10 }
# .each { |small| puts small }