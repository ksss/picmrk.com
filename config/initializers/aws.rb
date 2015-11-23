Aws.config[:profile] = "picmrk.com"
Aws.config[:region] = ENV['AWS_REGION'] || Rails.application.secrets.aws_region
