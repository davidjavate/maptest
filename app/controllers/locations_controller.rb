class LocationsController < ApplicationController

	def index
		@location = Location.all

		@features = Array.new
		#Go through locations db and push into features array
		@location.each do |location|
			@features << {
				type: 'Feature',
				geometry: {
					type: 'Point',
					coordinates: [location.longitude, location.latitude]
				},
				properties: {
					address: location.address,
					:'marker-color' => '#00607d',
					:'marker-symbol' => 'circle',
					:'marker-size' => 'medium',
					url: location_path(location)
				}
			}
		end

		#Add features array to @geojson to yield markers
		p @geojson = JSON.generate({
			type: 'FeatureCollection',
			features: @features
		})

		respond_to do |format|
			format.html
			format.json { render json: @features }  # respond with the created JSON object
		end
	end


	def new
	end


	def create
		new_address=params.require(:location).permit(:address)
		#Get latitude & longitude by using geocoder.
		new_coordinates = Geocoder.coordinates(new_address)
		@new_location = Location.create(new_address)
		p new_coordinates
		redirect_to locations_path
	end


	def show
		id = params[:id]
		@location= Location.find(id)

		@features = Array.new

		@features << {
				type: 'Feature',
				geometry: {
					type: 'Point',
					coordinates: [@location.longitude, @location.latitude]
							},
				properties: {
					address: @location.address,
					:'marker-color' => '#00607d',
					:'marker-symbol' => 'circle',
					:'marker-size' => 'medium'

							}
					}


		#Add features array to @geojson to yield markers
		p @geojson = JSON.generate({
			type: 'FeatureCollection',
			features: @features
		})

		respond_to do |format|
			format.html
			format.json { render json: @features }  # respond with the created JSON object
		end

	end

end
