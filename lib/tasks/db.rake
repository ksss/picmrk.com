namespace :db do
  desc "remove all photos record and uploaded file"
  task :remove_all_photos => :environment do
    Photo.find_each do |photo|
      photo.destroy!
    end
  end
end
