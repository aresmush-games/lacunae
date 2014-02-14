module AresMUSH
  class ClientMonitor
    def initialize(dispatcher, client_factory)
      @clients = []
      @dispatcher = dispatcher
      @client_factory = client_factory
    end

    attr_reader :clients, :client_id

    def emit_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end
    
    def emit_all_ooc(msg)
      @clients.each do |c|
        c.emit_ooc msg
      end
    end

    def connection_established(connection)
      begin
        client = @client_factory.create_client(connection, self)
        @clients << client
        client.connected
        @dispatcher.on_event(:connection_established, :client => client)
        Global.logger.info("Client connected from #{connection.ip_addr}. ID=#{client.id}.")
      rescue Exception => e
        Global.logger.debug "Error establishing connection Error: #{e.inspect}. \nBacktrace: #{e.backtrace[0,10]}"
      end
    end

    def connection_closed(client)
      Global.logger.info("Client #{client.id} disconnected.")
      @clients.delete client
      @dispatcher.on_event(:char_disconnected, :client => client)
    end
    
    def logged_in_clients
      @clients.select { |c| c.logged_in? }
    end
  end
end