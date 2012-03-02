class FacebookAccountsController < ApplicationController
  def index
    unless params[:code].blank?
      facebook_alerti = AlertiFacebook.new
      token = facebook_alerti.get_token(params[:code].to_s, facebook_accounts_url)
      FacebookAccount.create(:token => token)
    end
    @facebook_accounts = FacebookAccount.all
    
    respond_to do |format|
      format.html {}
    end
  end

end