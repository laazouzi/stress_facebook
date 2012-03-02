require File.join(File.dirname(__FILE__), 'string.rb')

class DaemonManager
  
  require 'net/http'

  
  SMS_HOST = "api.clickatell.com"
  SMS_PHONE = "212611475828"
  SMS_API_ID = "3276944"
  SMS_USER = "severine"
  SMS_PASSWORD = "clickatell2412"

  attr_accessor :daemon_name, :logger, :log_file, :log_size_file, :restarting
      
  def initialize(daemon_name, logger)
    self.daemon_name = daemon_name
    self.logger = logger
    self.log_file = File.join(RAILS_ROOT,"log","#{self.daemon_name.camelize}.log")
    self.log_size_file = "#{log_file}.size"
    self.restarting = false
    update_log_size
  end
  
  def update_log_size
    self.logger.info "updating #{self.daemon_name} log file size"
    File.open(self.log_size_file, 'w+') do |f| 
      if  File.exist?(self.log_file)
        f.write File.size(self.log_file) 
      else
        f.write "0"
      end    
    end
  end
  
  def check
    restart if !self.restarting && check_log_size=='failed'
  end
  
  def start
    daemon_folder = File.join(RAILS_ROOT,"script","background")    
    exec_cmd("cd #{daemon_folder} && ./#{self.daemon_name}.rb start #{ENV['RAILS_ENV']}", "restarting #{self.daemon_name}")
  end
  
  def restart
    self.restarting = true
    kill
    self.logger.info "waiting 1 minute before restarting #{self.daemon_name}"
    sleep 60
    start
    self.restarting = false
  end
  
  def check_log_size    
    new_log_size = 0
    if  File.exist?(self.log_file)
      new_log_size = File.size(self.log_file)    
    end
    if File.size?(self.log_size_file)
      old_log_size = File.read(self.log_size_file).to_i
      if new_log_size!=old_log_size        
        update_log_size
        return 'ok'
      else
        send_sms("check log failed for #{self.daemon_name} restarting in 1 minute")
        return 'failed'
      end
    else
      update_log_size
      return 'ok'
    end    
  end
  
  def kill
    daemon_pid_file = File.join(RAILS_ROOT,"log","#{self.daemon_name.camelize}.pid")
    self.get_pids.each { |pid| exec_cmd("kill -9 #{pid}", "Killing daemon #{self.daemon_name} (#{pid})") }   
    if File.exist?(daemon_pid_file)
      self.logger.info "delete #{self.daemon_name} pid file"
      File.delete(daemon_pid_file)     
    end
  end
  
  def exec_cmd(cmd, comment)
    self.logger.info "#{comment} : #{cmd}"
    self.logger.info `#{cmd}`
  end
  
  def get_pids
    pids = []    
    `ps -axo,pid,command | grep -i "#{self.daemon_name}.rb start" | grep -v "grep"`.split("\n").each do |line|
      splited_line = line.split(" ")
      pids << splited_line.first if splited_line.size>0
    end
    pids
  end  
  
  def send_sms(message)
    request = "/http/sendmsg?user=#{SMS_USER}&password=#{SMS_PASSWORD}&api_id=#{SMS_API_ID}&to=#{SMS_PHONE}&text=#{message}"
    self.logger.info "sending sms to #{SMS_PHONE}: #{message}"
    http = Net::HTTP.new(SMS_HOST, 80)
    response = http.request_get(request)
  end
end