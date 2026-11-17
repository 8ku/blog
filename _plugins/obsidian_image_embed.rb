Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  next unless doc.content
  image_dir = doc.site.config['image_path'] || '/assets/images'
  doc.content = doc.content.gsub(/!\[\[([^\]]+)\]\]/) do
    filename = $1.strip
    "![#{File.basename(filename, '.*')}](#{image_dir}/#{filename})"
  end
end
