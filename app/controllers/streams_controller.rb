class StreamsController < ApplicationController
  PAGE_PER = 3 * 13
  SINGULAR_METHODS = %i(show edit update destroy).freeze

  before_action :set_stream, only: SINGULAR_METHODS + %i(invite)
  before_action :set_current_account_stream, only: SINGULAR_METHODS
  before_action :filter_account_stream_member, only: SINGULAR_METHODS

  def index
    redirect_to root_path and return unless current_account

    @new_stream = Stream.new
    @account = current_account
    @streams = current_account.streams
  end

  def create
    stream = Stream.new(stream_params)
    stream.log = [{time: Time.now, message: 'created'}]
    stream.account_streams.build(account: current_account, status: 'owner')
    if stream.save
      redirect_to streams_path, notice: 'create stream' and return
    else
      redirect_to streams_path, alert: 'create stream failed' and return
    end
  end

  def invite
    account = Account.find_by name: account_params[:name]
    unless account
      redirect_to stream_path @stream.key, alert: "#{account_params[:name]} account not found" and return
    end

    account.account_streams.create stream: @stream, status: 'viewer'
    if account.save && @stream.write_log("invite from @#{current_account.name} to @#{account.name}")
      redirect_to stream_path @stream.key, notice: 'invited'
    else
      redirect_to stream_path @stream.key, alert: 'invite failed'
    end
  end

  def show
    @photos = @stream.photos.order(shot_at: :desc).page(params[:page]).per(PAGE_PER)
  end

  def edit
  end

  def update
    if @stream.update(stream_params)
      render :show
    else
      redirect_to edit_stream_path(@stream.key), alert: 'update failed' and return
    end
  end

  def destroy
    @stream.destroy
    redirect_to streams_path, notice: 'delete stream'
  end

  private

    def stream_params
      params.require(:stream).permit(:title, :status, :log)
    end

    def account_params
      params.require(:account).permit(:name)
    end

    def set_stream
      @stream = Stream.find_by key: params[:key]
      redirect_to streams_path, alert: "stream #{params[:key]} is not found" and return unless @stream
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
