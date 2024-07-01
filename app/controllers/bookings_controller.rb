class BookingsController < ApplicationController
	before_action :authenticate_user!

	def create
	    @showtime = Showtime.find(params[:showtime_id])
	    if @showtime.available_seats > 0
		    seat_number = (@showtime.bookings.maximum(:seat_number) || 0) + 1
		    @booking = @showtime.bookings.new(seat_number: seat_number, user: current_user)
		    if @booking.save
		        @showtime.update(available_seats: @showtime.available_seats - 1)
		        redirect_to movie_showtime_path(@showtime.movie, @showtime), notice: "Booking confirmed. Seat number: #{seat_number}"
		    else
		        redirect_to movie_showtime_path(@showtime.movie, @showtime), alert: "Failed to book seat."
		    end
	    else
	      	redirect_to movie_showtime_path(@showtime.movie, @showtime), alert: "No seats available."
	    end
	end

  	def destroy
	    @booking = Booking.find(params[:id])
	    @showtime = @booking.showtime
	    @booking.destroy
	    @showtime.update(available_seats: @showtime.available_seats + 1)
	    redirect_to movie_showtime_path(@showtime.movie, @showtime), notice: "Booking cancelled."
  	end
end
