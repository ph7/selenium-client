require 'timeout'
require 'socket'

class TCPSocket
  
  def self.wait_for_service(options)
    TCPSocket.wait until TCPSocket.service_running?(options)
  end
  
  def self.wait_until_stopped(options)
    TCPSocket.wait while TCPSocket.service_running?(options)
  end

  def self.service_running?(options)
    Timeout::timeout(options[:timeout] || 20) do
      !!begin
        TCPSocket.new(options[:host], options[:port])
      rescue Errno::ECONNREFUSED
      end
    end
  end

  def self.wait
    puts ".\n"
    sleep 2
  end

end