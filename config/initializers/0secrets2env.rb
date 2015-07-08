Rails.application.secrets.each do |key, value|
  ENV[key.upcase.to_s] = value.to_s
end
