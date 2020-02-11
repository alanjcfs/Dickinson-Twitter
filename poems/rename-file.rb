Dir.glob('./*.txt').each do |f|
  filename = File.basename(f)
  new_filename = filename.tr("\"'!?", '')
  puts new_filename
  File.rename(f, new_filename)
end
