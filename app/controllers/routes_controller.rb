class RoutesController < ApplicationController
  def show
    id = params["id"]
    if id.length < 3
      id = "0" * (3-id.length) + id
    end
    id = id.downcase
    route = Route.where(:uid => id).first
    render :text => route.to_hash.to_json
  end

  def index
    @routes = Route.all
  end
end
