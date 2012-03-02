class Entry < ActiveRecord::Base

  def self.get_graph_api_responses(daemon_logger = Rails.logger)
    afb = AlertiFacebook.new
    afb.retrieve_feeds(daemon_logger)
  end
end
