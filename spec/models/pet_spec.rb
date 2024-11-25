require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#trigger_apocalypse' do
    let(:pet) { create(:pet) }

    it 'creates an apocalypse for the pet' do
      expect { pet.trigger_apocalypse }.to change { pet.apocalypse }.from(nil)
    end
  end
end
