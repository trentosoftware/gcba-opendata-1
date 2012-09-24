class ApplicationController < ActionController::Base
  protect_from_forgery

<<<<<<< HEAD
  def index
  end
end
=======

  def index
    ParcelasData.where("user_name = '#{user_name}' AND password = '#{password}'").first
  end

  def parcelas_by_seccion

    ParcelasData.where("user_name = '#{user_name}' AND password = '#{password}'").first
  end
end
>>>>>>> 8e7520dea8650c5de1d9a4f48d1df6522c470779
