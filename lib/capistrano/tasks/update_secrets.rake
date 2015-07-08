namespace :secrets do
  desc 'upload secrets files'
  task :upload_secret_files do
    on roles :app do
      within release_path do
        info "upload secrets.yml"
        secrets = YAML.load(File.read("config/secrets.yml")).to_h
        upload! StringIO.new(secrets.to_yaml), "#{release_path}/config/secrets.yml"
      end
    end
  end
end
