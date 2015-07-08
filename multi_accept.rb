#! /usr/bin/env ruby

require 'socket'

case ARGV[0]
when 'server'
  sockfile = "/tmp/test.sock"
  File.unlink(sockfile) if File.exists?(sockfile)
  UNIXServer.open(sockfile) do |serv|
    File.chmod(0777, sockfile)
    serv.close_on_exec = false
    fd = serv.fileno
    3.times do
      fork do
        exec "ruby #{__FILE__} worker #{fd}", close_others: false
      end
    end
    Process.waitall
  end
when 'worker'
  fd = ARGV[1].to_i
  serv = UNIXServer.for_fd(fd)
  loop do
    sock = serv.accept
    sleep 1
    sock.write("hello #{Process.pid}")
    sock.close
  end
end

