$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientFactory do

    before do
      @dispatcher = double
      @factory = ClientFactory.new(@dispatcher)
      @connection = double.as_null_object
    end
      
    it "should initialize and return a client" do
      client = double
      client_monitor = double
      Client.should_receive(:new).with(1, client_monitor, @connection, @dispatcher) { client }
      @factory.create_client(@connection, client_monitor).should eq client
    end
    
    it "should create clients with incremental ids" do
      client1 = @factory.create_client(@connection, nil)
      client2 = @factory.create_client(@connection, nil)
      client1.id.should eq 1
      client2.id.should eq 2
    end 

    it "should tell the connection what its client is" do
      client = double
      Client.stub(:new) { client }
      @connection.should_receive(:client=).with(client)
      @factory.create_client(@connection, nil)
    end

  end
end
