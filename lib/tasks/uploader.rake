namespace :uploader do
  task :drop do
    if Rails.env.development?
      sh "rm -fr #{Rails.root.join('public', 'tori')}"
    end
  end

  task :migrate do
    if Rails.env.development?
      FileUtils.mkdir_p "#{Rails.root.join('public', 'tori', 'Photo')}"
    end
  end
end
