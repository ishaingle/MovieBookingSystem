class ShowtimesController < ApplicationController
	def show
		@showtime = Showtime.find(params[:id])
	end
end