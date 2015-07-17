class PhotosController < ApplicationController
  SINGULAR_METHODS = %i(show destroy update download).freeze
  before_action :set_photo, only: SINGULAR_METHODS
  before_action :photo_authenticate, only: SINGULAR_METHODS

  def new
  end

  def create
    if params[:stream_ids].nil? || params[:stream_ids].length == 0
      redirect_to :back, alert: 'please selecte any one stream' and return
    end

    params[:images].each do |image|
      create_photo image
    end

    redirect_to root_path and return
  end

  def destroy
    path = params[:stream_key].present? ? stream_path(params[:stream_key]) : streams_path
    if current_account_photo?
      if @photo.destroy
        redirect_to path, notice: 'destroy photo' and return
      else
        redirect_to path, alert: 'destroy photo failed' and return
      end
    else
      redirect_to :back, alert: 'unauthorized' and return
    end
  end

  def download
    send_data @photo.private_image.read, filename: @photo.filename
  end

  private

    def set_photo
      @photo = Photo.find_by(key: params[:key])
      redirect_to root_path, alert: "photo #{params[:key]} is not found" and return unless @photo
    end

    def create_photo(uploader)
      stream_ids = params[:stream_ids]
      tempfile = uploader.tempfile
      imagine = Imagine.new(tempfile)

      Tempfile.open("normalized_file") do |normalized_file|
        begin
          MiniMagick::Tool::Convert.new do |c|
            c.strip
            c.auto_orient
            c << tempfile.path
            c << normalized_file.path
          end

          Photo.new.tap { |photo|
            photo.account = current_account
            photo.image = normalized_file
            photo.private_image = tempfile
            photo.original_header = imagine.header
            photo.filename = uploader.original_filename
            photo.size = tempfile.size
            photo.content_type = uploader.content_type
            photo.shot_at = imagine.shot_time || Time.zone.now
            photo.stream_ids = stream_ids
            photo.key = Base58.key_digest58
            photo.private_name = Base58.key_digest58(32)
            photo.image.write(acl: 'private') if photo.image.from?
            photo.private_image.write(acl: 'private') if photo.private_image.from?
            photo.save!
          }
        ensure
          normalized_file.unlink
        end
      end
    ensure
      uploader.tempfile.unlink
    end

    def photo_authenticate
      if !current_account_photo?
        redirect_to root_path, alert: 'unauthorized' and return
      end
    end

    def current_account_photo?
      current_account.try(:id) == @photo.account.id
    end
end
