Tori.config.filename_callback do |model|
  "#{model.class.name}/#{model.key}"
end
