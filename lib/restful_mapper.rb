module ActionController
  module Routing
    class RouteSet 
      class Mapper
        def restfully( resource_name ) #:nodoc:
          singular_resource_name = resource_name.to_s.singularize
          plural_resource_name = resource_name.to_s.pluralize

          named_route( singular_resource_name, singular_resource_name + "/:id", { :controller => plural_resource_name, :id => nil, :grammatical_number => 'singular' } )
          named_route( plural_resource_name, plural_resource_name + "/:ids", { :controller => plural_resource_name, :ids => nil, :grammatical_number => 'plural' } )
          named_route( 'formatted_' + singular_resource_name, singular_resource_name + "/:id.:format", { :controller => plural_resource_name, :id => nil, :grammatical_number => 'singular' } )
          named_route( 'formatted_' + plural_resource_name, plural_resource_name + "/:ids.:format", { :controller => plural_resource_name, :id => nil, :grammatical_number => 'plural' } )
          named_route( 'formatted_without_id_' + singular_resource_name, singular_resource_name + ".:format", { :controller => plural_resource_name, :grammatical_number => 'singular' } )
          named_route( 'formatted_without_ids' + plural_resource_name, plural_resource_name + ".:format", { :controller => plural_resource_name, :grammatical_number => 'plural' } )

          %w( get put post delete ).each do |method|
            named_route( method + "_" + singular_resource_name, singular_resource_name + "/:id", { :controller => plural_resource_name, :id => nil, :grammatical_number => 'singular', :conditions => { :method => method } } )
            named_route( method + "_" + plural_resource_name, plural_resource_name + "/:ids", { :controller => plural_resource_name, :ids => nil, :grammatical_number => 'plural', :conditions => { :method => method } } )
          end
        end
      end
    end
  end
end

