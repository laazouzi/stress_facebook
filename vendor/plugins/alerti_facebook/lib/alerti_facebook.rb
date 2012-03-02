# Facebook pages
class AlertiFacebook
  
  include HTTParty
  base_uri 'https://graph.facebook.com'
  headers 'User-Agent' => 'Ruby HTTParty'
  default_timeout(120)

  MAX_POSTS = 25
  
  def initialize
    path = File.join(Rails.root, "config/facebook.yml")
    if !File.exists?(path)
      raise StandardError, "You must create config/facebook.yml to use this lib"
    else
      @config = YAML.load_file(path) || {} 
      @app_id = config_value('app_id')
      @secret_key = config_value('secret_key')
      @perms = "offline_access,manage_pages,publish_stream"
    end
  end
  
  def config_value(key)
    if @config[Rails.env] && @config[Rails.env][key]
      @config[Rails.env][key]
    elsif @config[key]
      @config[key]
    else
      ""
    end
  end

  def get_token(code, redirection_url)
    query = {}
    query[:client_id] = @app_id
    query [:redirect_uri] = redirection_url
    query[:client_secret] = @secret_key
    query [:code] = code
    response = AlertiFacebook.get("https://graph.facebook.com/oauth/access_token?"+query.to_query)
 
    if response.include?("error")
      return response["error"]
    else
      return CGI::parse(response.body).symbolize_keys[:access_token].try(:first).to_s
    end
  end

  def auth_link(redirection_url)
    "https://www.facebook.com/dialog/oauth?client_id=#{@app_id}&redirect_uri=#{redirection_url}&scope=#{@perms}"
  end

  def retrieve_feeds(daemon_logger)
    tokens = FacebookAccount.all.map(&:token)
    page_ids = FacebookFanPage.all.map(&:page_id)
    tokens.each do |token|
      page_ids.each do |page_id|
        next_page = true
        request_counter = 1
        page_feed_url = "https://graph.facebook.com/#{page_id}/feed?"+{:access_token => token, :limit => MAX_POSTS}.to_query
        daemon_logger.info "starting requests on the facebook graph API #{page_id}"
        exceptions_count = 0
        while(next_page)
          response = {}
          begin
            response = AlertiFacebook.get(page_feed_url)
          rescue Exception => e
            daemon_logger.info "Error on HTTPrty Response"
            ExceptionLog.create(:message => e.message, :backtrace => e.backtrace)
            exceptions_count += 1
            next_page = false if exceptions_count > 20
          end
          Entry.create(:url => page_feed_url, :http_code => response.code, :response_body => response.body) if response.present?
          page_feed_url = ""
          page_feed_url = response['paging']['next'] if response['paging'].present? && response['paging']['next'].present?
          daemon_logger.info "[#{Time.now.strftime('%d/%m/%Y %H:%M:%S')}] request #{request_counter}: on the facebook graph API #{page_id}"
          next_page = false if page_feed_url.blank?
          request_counter += 1
        end
      end
    end
  end
end
