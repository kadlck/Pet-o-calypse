class ApocalypseController < ApplicationController
  def index
    @pet = Pet.find(params[:pet_id]) # Ensure you pass `pet_id` when navigating
    @apocalypse = @pet.apocalypse
    @events = @apocalypse.events
  end

  def show
    @apocalypse = Apocalypse.find(params[:id])
  end
end
