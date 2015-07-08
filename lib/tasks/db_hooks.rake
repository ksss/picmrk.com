namespace :db do
  Rake::Task[:'db:drop'].enhance([:'uploader:drop'])
  Rake::Task[:'db:migrate'].enhance([:'uploader:migrate'])
end
