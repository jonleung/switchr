# require 'em-websocket'

class Notifier
  
  #class
  def self.set_n_array(n_array)
    @n_array = n_array
  end
    
  def self.notify(msg)
    @n_array.each do |n|
      puts "notifying"
      n.send msg
    end
  end
  
  def self.get_n_array
    @n_array
  end
  
  #instance
  def initialize(ws)
    @is_open = false
    @ws = ws
  end
  
  def send(msg)
    if @is_open
      @ws.send msg
    end
  end
  
  def open
    @is_open = true
  end
  
end

n_array = Array.new
ws_array = Array.new

Notifier.set_n_array(n_array)

Thread.new {
  EM.run {

    EM::WebSocket.start(:host => "0.0.0.0", :port => 9999) do |ws|
      
        ws.onopen {
          puts "WebSocket connection open"
          ws.send "Hello Client"
          n = Notifier.new(ws)
          n.open
          n_array << n
          ws_array << ws
        }
        ws.onclose {
          puts "Connection Closed"
          i = ws_array.index ws
          n_array.delete_at i
          ws_array.delete_at i
        }
        ws.onmessage { |msg|
          puts "Recieved message: #{msg}"
      
          regex = /(\d+),(\d)/
          match = regex.match(msg)
          if match.present?
            #Device.update_state(match[1],match[2])
            LOG("SET:#{match[1]},#{match[2]}")
            puts("SET:#{match[1]},#{match[2]}")
          end
        }
    end
  }
}

puts "Notifier Initialized"