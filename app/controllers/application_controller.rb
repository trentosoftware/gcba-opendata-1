class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    ParcelasData.where("user_name = '#{user_name}' AND password = '#{password}'").first
  end

  def parcelas_by_seccion
    ParcelasData.where("user_name = '#{user_name}' AND password = '#{password}'").first
  end
end
