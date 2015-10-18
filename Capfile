# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano3/unicorn'
require 'capistrano/foreman'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

require 'aws-sdk'

Aws.config[:profile] = "picmrk.com"
Aws.config[:region] = ENV["AWS_REGION"]

class DescribeInstances
  include Enumerable

  def initialize
    client = Aws::EC2::Client.new
    @resource = Aws::EC2::Resource.new(client: client)
  end

  def each(&block)
    return to_enum unless block

    res = @resource.instances(filters: [
      {name: 'instance-state-name', values: ['running']}
    ])

    res.each do |instance|
      def instance.name
        tags.find{|tag| tag.key == "Name"}.value
      end
      def instance.roles
        roles = tags.find{|tag| tag.key == "Roles"}
        roles.nil? ? [] : roles.value.split(',')
      end
      yield instance
    end
  end
end
