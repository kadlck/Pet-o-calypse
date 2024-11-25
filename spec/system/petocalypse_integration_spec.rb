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
    select 'dog_wizard', from: 'Species'
    click_button 'Create Pet'

    expect(page).to have_content('Fluffy')
  end

  it 'does not allow non-logged-in users to access pets' do
    sign_out user
    visit pets_path
    expect(page).to have_content('You need to sign in')
  end
end
