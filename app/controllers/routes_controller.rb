class RoutesController < ApplicationController
  def show
    route = Route.where(:uid => params["id"]).first
    render :text => route.to_hash.to_json
  end

  def index
    @routes = Route.all
  end
end
