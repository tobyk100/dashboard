class SessionsController < Devise::SessionsController

  before_filter :nonminimal

end
