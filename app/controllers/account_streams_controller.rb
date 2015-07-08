class AccountStreamsController < ApplicationController
  before_action :set_account
  before_action :set_stream

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

    def set_account
      @account = Account.find_by name: params[:account_name]
    end

    def set_stream
      @stream = Stream.find_by key: params[:stream_key]
    end
end
