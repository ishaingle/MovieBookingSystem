class BookingsController < ApplicationController
	before_action :authenticate_user!

	def create
	  @showtime = Showtime.find(params[:showtime_id])
		if @showtime.available_seats > 0
	    canceled_booking = @showtime.bookings.find_by(status: 'canceled')

	    if canceled_booking.present?
      	seat_number = canceled_booking.seat_number
      	canceled_booking.update(status: 'booked', user: current_user)
      	@showtime.update(available_seats: @showtime.available_seats - 1)
	    else
      	seat_number = (@showtime.bookings.maximum(:seat_number) || 0) + 1
      	@booking = @showtime.bookings.new(seat_number: seat_number, user: current_user, status: 'booked')

      	if @booking.save
        	@showtime.update(available_seats: @showtime.available_seats - 1)
        	redirect_to movie_showtime_path(@showtime.movie, @showtime), notice: "Booking confirmed. Seat number: #{seat_number}"
        	return
      	else
        	redirect_to movie_showtime_path(@showtime.movie, @showtime), alert: "Failed to book seat."
        	return
      	end
	    end

	    redirect_to movie_showtime_path(@showtime.movie, @showtime), notice: "Booking confirmed. Seat number: #{seat_number}"
		else
		  redirect_to movie_showtime_path(@showtime.movie, @showtime), alert: "No seats available."
		end
	end

	def destroy
  	@booking = Booking.find(params[:id])
  	@showtime = @booking.showtime
  
  	if @booking.update(status: 'canceled')
    	@showtime.update(available_seats: @showtime.available_seats + 1)
    	redirect_to movie_showtime_path(@showtime.movie, @showtime), notice: "Booking canceled."
  	else
    	redirect_to movie_showtime_path(@showtime.movie, @showtime), alert: "Failed to cancel booking."
  	end
	end
end
