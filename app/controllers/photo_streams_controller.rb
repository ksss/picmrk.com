class PhotoStreamsController < ApplicationController
  skip_before_action :authenticate, only: %i(show)
  before_action :set_photo
  before_action :set_stream

  def show
    @photo_stream = PhotoStream.find_by(stream: @stream, photo: @photo)
  end

  def create
    @photo.streams << @stream
    respond_to do |format|
      if @photo.save && @stream.write_log("add photo")
        format.html { redirect_to photo_path(@photo.key) }
        format.js { render 'photos/stream' }
      else
        format.html { redirect_to photo_path(@photo.key), alert: 'add streams failed' }
        format.js { render text: "console.log('update failed')" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @photo.streams.length <= 1
        render text: 'stream must be one over', status: 400 and return
      end
      if @photo.streams.destroy(@stream) && @stream.write_log("delete photo")
        format.html { redirect_to photo_path(@photo.key) }
        format.js { render 'photos/stream' }
      else
        format.html { redirect_to photo_path(@photo.key), alert: 'remove streams failed' }
        format.js { render text: "console.log('destroy failed')" }
      end
    end
  end

  private

    def set_photo
      @photo = Photo.find_by key: params[:photo_key]
    end

    def set_stream
      @stream = Stream.find_by key: params[:stream_key]
    end
end
