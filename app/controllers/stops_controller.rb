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

  # Stop.all.each do |stop|
  #     y = stop.x
  #     x = stop.y
  #     stop.x = x
  #     stop.y = y
  #     stop.save
  # end

  # center: (49.282910,-123.109231)
  # boundBox: (-123.102364,49.277775,-123.116096,49.288048)
  # bound box
  # (-123.102364 < x AND x < -123.116096 )
  def in
    x1,y1,x2,y2 = params[:coords].split(",").map { |f| Float(f) }
    uids = Stop.select("distinct uid").where(["? < x AND x < ? ",x1,x2]).where(["? < y AND y < ? ",y2,y1]).all
    stops = Stop.where("uid" => uids.map(&:uid)).includes(:route)
    # cx = (x2 - x1).abs / 2.0
    # cy = (y2 - y1).abs / 2.0
    # stops.all.
    # [{"description" =
    #    "W Hastings St @ Hamilton St",
    #    "latlng":[49.282316,-123.109282],
    #    "id":"52712 ",
    #    "direction":"E",
    #    "routes": {
    #      "004" : ["10:10", "10:14", "10:20"],
    #  "15": ["10:10", "10:14", "10:20"],
    #  "21N":["10:10", "10:14", "10:20"]}}]
    # -123.16789&lat=49.25344
    # -123.1, -123.2
    # 49.2,49.3
    # -123.1,49.2,123.2,49.3
    # http://localhost:3000/stops/in/-123.1,49.2,-123.09,49.3
    # http://localhost:3000/stops/in/-123.116096,49.288048,-123.102364,49.277775
    @json = stops.map do |stop|
      route_stops = Stop.where(:uid => stop.uid).includes(&:route).all
      { "description" => stop.name,
        "latlng" => [stop.y,stop.x],
        "id" => stop.uid,
        "direction" => (stop.direction == "West" ? "W" : "E"),
        "routes" => route_stops.inject({}) { |h,route_stop|
          h[route_stop.route.uid] = route_stop.times
          h
        }
      }
    end

    render :text => @json.to_json
  end
end
