Tori.config.tap do |config|
  case Rails.env
  when "development"
    config.backend = Tori::Backend::FileSystem.new(Rails.root.join("public/tori"))
  else
    config.backend = Tori::Backend::S3.new(bucket: Rails.application.config.tori_aws_s3_bucket)
  end
  config.filename_callback do |model|
    "#{model.class.name}/#{model.key}"
  end
end
