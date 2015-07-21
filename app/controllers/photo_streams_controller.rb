class PhotoStreamsController < ApplicationController
  SINGULAR_METHODS = %i(show edit update destroy).freeze

  before_action :set_photo
  before_action :set_stream
  before_action :set_current_account_stream, only: SINGULAR_METHODS
  before_action :filter_account_stream_member, only: SINGULAR_METHODS

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

    def set_current_account_stream
      @current_account_stream = AccountStream.find_by(account: current_account, stream: @stream)
    end

    def filter_account_stream_member
      unless @current_account_stream
        redirect_to root_path, alert: 'unauthorized' and return
      end
    end
end
