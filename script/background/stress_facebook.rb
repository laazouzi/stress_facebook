#!/usr/bin/env ruby

ENV['RAILS_ENV'] = ARGV[1] || 'development'

require File.dirname(__FILE__) + '/../../config/environment'
require 'simple-daemon'

class Logger
  def format_message(severity, timestamp, progname, msg)
    "[#{timestamp.to_formatted_s(:short)} PID:#{$$}] #{msg}\n"
  end
end


class StressFacebook < SimpleDaemon::Base 
	
	def self.stress_it
		begin
			@logger.info "start a daemon iteration"
      Entry.get_graph_api_responses(@logger)
		rescue  Exception => e
      ExceptionLog.create(:message => e.message, :backtrace => e.backtrace)
      @logger.error "Error in daemon #{e.class.name}: #{e.message}"
			if e.is_a?(ActiveRecord::StatementInvalid)
				@logger.error "trying to reconnect"
				ActiveRecord::Base.connection.reconnect! 
			else      		
				@logger.info e.backtrace.join("\n")
			end        
		end    
    EM.add_timer(1) { self.stress_it }
	end 
      
  def self.start        
    STDOUT.sync = true
    @logger = Logger.new(STDOUT)
    EM.run { StressFacebook.stress_it }
  end

  def self.stop
    EM.stop
    puts "Stopping processor" 
  end  
end

SimpleDaemon::WORKING_DIRECTORY = "#{RAILS_ROOT}/log" 

if File.exist?("#{SimpleDaemon::WORKING_DIRECTORY}/StressFacebook.pid") && ARGV[0] == 'start'
  puts "Another daemon is running"
else  
  StressFacebook.daemonize
end