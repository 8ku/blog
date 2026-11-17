# _plugins/obsidian_images.rb

Jekyll::Hooks.register :site, :pre_render do |site|
  image_root = File.join(site.source, 'assets', 'images')
  $obsidian_image_map = {}
  $obsidian_baseurl = site.config['baseurl'] || ''

  next unless Dir.exist?(image_root)

  Dir.glob(File.join(image_root, '**', '*')).each do |path|
    next if File.directory?(path)
    filename = File.basename(path)
    rel_path = path.sub(site.source, '').gsub('\\', '/')

    if $obsidian_image_map.key?(filename)
      Jekyll.logger.warn "ObsidianImages:", "Duplicate filename '#{filename}' — keeping first match (#{$obsidian_image_map[filename]})"
    else
      $obsidian_image_map[filename] = rel_path
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  next unless doc.content

  doc.content = doc.content.gsub(/!\[\[([^\]|]+)\]\]/) do
    filename  = $1.strip
    real_path = $obsidian_image_map[filename]

    if real_path
      "![#{File.basename(filename, '.*')}](#{$obsidian_baseurl}#{real_path})"
    else
      Jekyll.logger.warn "ObsidianImages:", "No file found for ![[#{filename}]] in #{doc.relative_path}"
      "![#{filename}](MISSING:#{filename})"
    end
  end
end
