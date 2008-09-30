puts <<-SETUP
You are ready to map restfully.  You will probably want to modify 
your ApplicationController to include the RestfulController module:

class ApplicationController < ActionController::Base
  include RestfulController
end
  
and define your routes in config/routes.rb with map.restfully like:

ActionController::Routing::Routes.draw do |map|
  map.restfully :user
  map.restfully :page
  map.restfully :active_record_model_name etc...

end

See the README (vendor/plugins/map_restfully/README) for more details
or visit: http://github.com/progmatica/map_restfully/tree/master
SETUP
