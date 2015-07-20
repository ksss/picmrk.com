class AccountStreamsController < ApplicationController
  before_action :set_account
  before_action :set_stream

  def create
    account = Account.find_by name: account_params[:name]
    unless account
      redirect_to stream_path(@stream.key), alert: "#{account_params[:name]} account not found" and return
    end

    account.account_streams.create stream: @stream, status: 'viewer'
    if account.save && @stream.write_log("invite from @#{current_account.name} to @#{account.name}")
      redirect_to stream_path(@stream.key), notice: 'invited' and return
    else
      redirect_to stream_path(@stream.key), alert: 'invite failed' and return
    end
  end

  def update
    stream = Stream.find_by key: params[:stream_key]
    unless stream
      redirect_to streams_path, alert: "stream #{params[:key]} is not found" and return
    end

    current_account_stream = AccountStream.find_by(account: current_account, stream: stream)
    unless current_account_stream.owner?
      redirect_to edit_stream_path(stream.key) and return
    end

    account = Account.find_by(name: params[:account_name])
    account_stream = AccountStream.find_by(account: account, stream: stream)
    if account_stream.update(account_stream_params)
      redirect_to edit_stream_path(stream.key), notice: 'updated' and return
    else
      redirect_to edit_stream_path(stream.key), alert: 'update failed' and return
    end
  end

  def destroy
    if @account.streams.destroy(@stream) && @stream.write_log("leave")
      if @stream.accounts.empty?
        if @stream.destroy
          redirect_to streams_path, notice: 'leave and destroy stream' and return
        else
          redirect_to stream_path(@stream.key), notice: 'destroy stream failed' and return
        end
      end
      redirect_to stream_path(@stream.key), notice: 'leave stream' and return
    else
      redirect_to stream_path(@stream.key), alert: 'leave stream failed' and return
    end
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def account_stream_params
    params.require(:account_stream).permit(:status)
  end

  def set_account
    @account = Account.find_by name: params[:account_name]
  end

  def set_stream
    @stream = Stream.find_by key: params[:stream_key]
  end
end
