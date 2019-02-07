class Api::PlacesController < Api::BaseController

  def index
    place_details
    barnaby = Place.all.select { |place| place.address.downcase.include?(place_params[:q].downcase) }
    finalplaces = { 'barnaby' => barnaby, 'google_suggestions' => @googlearray}
    render json: finalplaces, status: :ok
  end

private

  def place_params
    params.permit(:q)
  end

  def init
    @apikey = request.headers["Authorization"]
    @google_api_base_url = "https://maps.googleapis.com/maps/api/"
    @barnabyplaces = Place.all
  end

  def google_autocomplete
    init
    input = place_params[:q]
    url = @google_api_base_url + "place/autocomplete/json?input=#{input}&types=establishment&key=#{@apikey}"
    json = JSON.parse RestClient.get(url)
    fivepredictionsarray = json['predictions']
    @resultarray = []
    fivepredictionsarray.each do |prediction|
      @resultarray << { 'name' => prediction['description'], 'placeid' => prediction['place_id'] }
      end
    @resultarray
  end

  def place_details
    google_autocomplete
    @googlearray = []
    @resultarray.each do |result|
      place_id = result['placeid']
      url = @google_api_base_url + "place/details/json?placeid=#{place_id}&key=#{@apikey}"
      json = JSON.parse RestClient.get(url)
      coordinates = json['result']['geometry']['location']
      latitude = coordinates['lat']
      longitude = coordinates['lng']
      @googlearray <<  {'name' => result['name'], 'latitude' => latitude, 'longitude' => longitude}
    end
  @googlearray
  end
end
