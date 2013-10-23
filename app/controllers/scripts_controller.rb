class ScriptsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
end