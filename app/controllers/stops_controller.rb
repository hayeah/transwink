class StopsController < ApplicationController
  def show
    stops = Stop.where(:uid => params["id"].split(",")).all
    @json =  stops.inject({}) do |h,stop|
      h[stop.uid] ||= []
      h[stop.uid] << {
        "times" => stop.times,
        "direction" => stop.direction,
        "stop_id" => stop.uid,
        "route_id" => stop.route.uid
      }
      h
    end
    render :text => @json.to_json
  end
end
