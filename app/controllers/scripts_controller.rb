class ScriptsController < ApplicationController
  check_authorization
  before_filter :authenticate_user!
end