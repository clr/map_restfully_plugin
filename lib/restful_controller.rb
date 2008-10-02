module RestfulController

  # Bootstrap the class methods.
  def self.included( klass )
    klass.extend ClassMethods
    klass.before_filter :prepare_restful_action
    klass.before_filter :prepare_restful_instance_variables
  end
  
#
# Class Methods.
#
  module ClassMethods
  end

#
# Instance Methods.
#
# All methods return a status code of 405 by default, which is "Method not allowed."  This
# requires that all actions be explicitly defined in the controllers, which is better for 
# security, even if it is as simple as 'def gets; end'
#

  [ :gets, :posts, :puts, :deletes, :get, :post, :put, :delete ].each do |action|
    define_method action do
      respond_to do |format|
        format.html { render :text => "<html><body><h1>405: Method not allowed.</h1><p>#{ action.to_s.capitalize } called from '#{ self.class.name }' with: #{ self.instance_variables.inspect }</p><p>You must explicitly define this action in your controller if you wish to use it.</p></body></html>", :status => 405 }
      end
    end
  end


  def prepare_restful_action
    case params[:grammatical_number]
    when 'plural'
      self.action_name = self.request.request_method.to_s.pluralize
    when 'singular'
      self.action_name = self.request.request_method.to_s.singularize
    end
  end

  def prepare_restful_instance_variables
    resource_class_name = params[:controller].to_s.singularize.camelize
#    if ::Object.const_defined?( resource_class_name )
    # Check for availability of matching model class.  This won't always work, because
    # the model class may not have been loaded yet if this is our first time using
    # that model; hence, the rescue below.
    begin
      resource_class = resource_class_name.constantize 
      case params[:grammatical_number]
      when 'plural'
        instances_name = ( "@" + params[:controller].to_s.pluralize ).to_sym
        if params[:ids]
          instance_variable_set instances_name, resource_class.find( params[:ids].split( ',' ) ) 
        else
          instance_variable_set instances_name, resource_class.find( :all )
        end 
      when 'singular'
        instance_name = ( "@" + params[:controller].to_s.singularize ).to_sym
        if params[:id].to_i == 0
          instance_variable_set instance_name, resource_class.new 
        else
          instance_variable_set instance_name, resource_class.find( params[:id] ) if params[:id]
        end
      end
    rescue NameError => e
      # Just continue on our way.  There is no model by that name.
    end
  end

end
