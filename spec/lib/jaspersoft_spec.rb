require 'spec_helper'

describe Jaspersoft::Configuration do
  Jaspersoft::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe "#{key}" do
      it "should return the default value" do
        Jaspersoft.send(key).should == Jaspersoft::Configuration.const_get("DEFAULT_#{key.upcase}")
      end
    end
  end    

  describe "#configure" do
    Jaspersoft::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set #{key}" do
        Jaspersoft.configure do |config|
          config.send("#{key}=", key)
          Jaspersoft.send(key).should == key
        end
      end        
    end
  end
end

describe Jaspersoft::Client do
  before do
    @keys = Jaspersoft::Configuration::VALID_CONFIG_KEYS
  end

  describe 'with module configuration' do
    before do
      Jaspersoft.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Jaspersoft.reset!
    end

    it "should inherift module configuration" do
      api = Jaspersoft::Client.new
      @keys.each do |key|
        api.send(key).should == key
      end
    end

    describe "with class configuration" do
      before do
        @config = {
          username: 'bob',
          password: 'mypassword',
          endpoint: 'localhost',
          adapter: 'net_http',
          report_file_type: 'pdf',
          enterprise_server: false,
        }
      end

      it "should override module configuration" do
        api = Jaspersoft::Client.new(@config)
        @keys.each do |key|
          api.send(key).should == @config[key]
        end
      end

      it "should override module configuration after" do
        api = Jaspersoft::Client.new
        
        @config.each do |key, value|
          api.send("#{key}=", value)
        end

        @keys.each do |key|
          api.send("#{key}").should ==  @config[key]
        end
      end

    end
  end
end