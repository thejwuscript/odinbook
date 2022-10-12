require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  # create a user as subject.
  
  context 'when the user enters and submits valid credentials' do
    it 'signs up successfully and redirects to homepage' do
      
    end
  end

  context 'when the user enters and submits invalid credentials' do
    it 'shows error messages corresponding to the invalid fields' do
      
    end

    it 'revalidates and updates error messages accordingly' do
      
    end
  end
end