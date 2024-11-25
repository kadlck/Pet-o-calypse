class ApocalypsesController < ApplicationController
  def index
    @pet = Pet.find(params[:pet_id])
    @apocalypse = @pet.apocalypse
    @events = @apocalypse.events
  end

  def show
    @apocalypse = Apocalypse.find(params[:id])
  end

  def event
    @pet = Pet.find(params[:pet_id])
    @apocalypse = @pet.apocalypse
    @event = @apocalypse.events.find(params[:apocalypse_id])
  end
end
