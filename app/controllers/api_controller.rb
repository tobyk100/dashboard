class ApiController < ApplicationController
  def user_menu
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    render layout: false
  end
end