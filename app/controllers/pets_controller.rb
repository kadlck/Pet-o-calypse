class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: [ :show, :trigger_apocalypse, :destroy ]

  def index
    @pets = current_user.pets
  end

  def destroy
    @pet.destroy
    redirect_to root_path
  end

  def show
    if @pet.apocalypse_ready?
      redirect_to post_apocalypse_pet_path(@pet)
    end
  end

  def trigger_apocalypse
    if @pet.update(apocalypse_ready: true)
      @pet.trigger_apocalypse
      flash[:notice] = "The apocalypse is upon us!"
      redirect_to post_apocalypse_pet_path(@pet)
    else
      flash[:alert] = "Something went wrong!"
      redirect_to pet_path(@pet)
    end
  end

  def post_apocalypse
    @pet = Pet.find(params[:id])
    unless @pet.apocalypse_ready?
      redirect_to pet_path(@pet)
    end
  end

  def feed
    @pet = Pet.find(params[:id])
    @pet.decrease_hunger(10)
    @pet.save
    redirect_to pet_path(@pet)
  end

  def play
    @pet = Pet.find(params[:id])
    @pet.increase_happiness(10)
    @pet.save
    redirect_to pet_path(@pet)
  end

  def nap
    @pet = Pet.find(params[:id])
    @pet.increase_health(10)
    @pet.save
    redirect_to pet_path(@pet)
  end

  def scavenge
    @pet = Pet.find(params[:id])
    redirect_to pet_apocalypses_path(@pet)
  end

  def fight
    @pet = Pet.find(params[:id])
    random_event = @pet.apocalypse.events.sample
    if random_event.present?
      outcome_message = random_event.process_event(@pet)
    else
      flash[:notice] = "No events available to fight."
    end
    flash[:notice] = outcome_message
    redirect_to pet_apocalypse_event_path(@pet, random_event)
  end

  def hide
    @pet = Pet.find(params[:id])
    @pet.increase_health(1) # Increase pet's health
    if @pet.save
      flash[:success] = "Your pet successfully hid and regained some health!"
    else
      flash[:alert] = "Something went wrong while hiding."
    end
    redirect_to pet_path(@pet)
  end

  # Action to show form for creating a new pet
  def new
    @pet = Pet.new
    @available_pets = Pet.load_all_pets.keys # Load pet types from YAML for the form
  end

  # Action to create a new pet
  def create
    @pet = current_user.pets.build(pet_params)

    if @pet.save
      flash[:success] = "#{@pet.name} the #{@pet.species} has been created!"
      redirect_to pet_path(@pet)
    else
      flash[:error] = "There was an issue creating your pet. Please try again."
      render :new
    end
  end

  def unlock_history
    @pet = Pet.find(params[:id])
    next_history = @pet.unlock_next_history

    if next_history
      flash[:notice] = "New history unlocked: #{next_history}"
    else
      flash[:alert] = "No more histories to unlock!"
    end

    redirect_to pet_path(@pet)
  end


  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:name, :species)
  end
end
