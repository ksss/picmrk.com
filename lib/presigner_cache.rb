class PresignerCache
  class << self
    def url(method, params = {})
      @map ||= {}
      if @map[[method, params]] && @map[[method, params]].expires_in?
        @map[[method, params]].url
      else
        @map[[method, params]] = new(method, params)
        url(method, params)
      end
    end
  end

  def initialize(method, params = {})
    @method = method
    @params = params
    expires_in = params.delete(:expires_in) || Aws::S3::Presigner::FIFTEEN_MINUTES
    @expires_time = Time.now.utc + expires_in
    @presigned_url = new_url(method, params)
  end

  def expires_in?
    Time.now.utc < @expires_time
  end

  def url
    @presigned_url
  end

  def new_url(method, params = {})
    signer = Aws::S3::Presigner.new
    signer.presigned_url(method, params)
  end
end
