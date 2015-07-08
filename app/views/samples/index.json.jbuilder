json.array!(@samples) do |sample|
  json.extract! sample, :id, :sname
  json.url sample_url(sample, format: :json)
end
