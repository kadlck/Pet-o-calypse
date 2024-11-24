class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @pet = @event.apocalypse.pet
  end

  def attempt
    @event = Event.find(params[:id])
    @pet = @event.apocalypse.pet

    outcome = @event.process_outcome(@pet)

    flash[:notice] = outcome
    redirect_to pet_apocalypse_path(@pet)
  end
end
