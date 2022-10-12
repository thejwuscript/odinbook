require 'rails_helper'

RSpec.describe 'Log in', type: :system do
  subject(:user) { create(:user) }

  context 'when the user fills in the correct credentials' do
    it 'logs in user and redirects to homepage' do
      visit root_path

      fill_in "user_login", with: user.login
      fill_in "user_password", with: user.password
      click_on "Log in"

      sleep(5)

      expect(page).to have_current_path(root_path)
    end
  end

  context 'when the user fills in the wrong credentials' do
    it 'displays an error flash message on the same page' do
      
    end
  end
end