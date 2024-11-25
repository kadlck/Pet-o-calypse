require 'rails_helper'

RSpec.describe PetsController, type: :controller do
  let(:user) { create(:user) }
  let(:pet) { create(:pet) }

  before do
    sign_in user # Devise helper to log in a user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'PATCH #feed' do
    it 'updates the pet and redirects to pet page' do
      patch :feed, params: { id: pet.id }
      expect(response).to redirect_to(pet_path(pet))
    end
  end
end
