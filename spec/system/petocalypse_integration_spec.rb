require 'rails_helper'

RSpec.describe 'User manages pets', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    sign_in user # Devise helper to log in a user
  end

  it 'allows a logged-in user to create a pet' do
    visit new_pet_path

    fill_in 'Name', with: 'Fluffy'
    select 'rabbit_necromancer'.capitalize, from: 'Species'
    click_button 'Create Pet'

    expect(page).to have_content('Fluffy')
  end
end
