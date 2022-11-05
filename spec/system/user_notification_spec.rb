require 'rails_helper'

RSpec.describe 'Notifications', type: :system, js: true do
  let!(:notification) { create(:notification) }
  let(:headline1) { create(:headline) }
  let(:headline2) { create(:headline) }
  let(:headline3) { create(:headline) }

  before do
    allow(Headline).to receive(:create).and_return(headline1, headline2, headline3)
    stub_request(:get, /newsapi.org/).to_return(status: 200,
                                                body: File.read(Rails.root.join('spec/support/assets/response.json')))
  end

  context 'when notifications are unread' do
    before do
      sign_in notification.receiver
      visit root_path
    end

    it 'shows the number of unread notifications on the icon' do
      within '.notification-badge' do
        expect(page).to have_content('1')
      end
    end
  end

  context 'when the notification icon is clicked' do
    before do
      sign_in notification.receiver
      visit root_path
      find('button[title="Notifications"]').click
    end

    it 'removes the count' do
      within '.notification' do
        expect(page).not_to have_css('.notification-badge')
      end
    end

    it 'drops down a list of notifications received', :aggregate_failures do
      expect(page).to have_css('.notification-dropdown-container')
      expect(page).to have_content("#{notification.sender.name} sent you a friend request.")
    end
  end

  context 'when the user clears all notifications by clicking the x icons' do
    before do
      sign_in notification.receiver
      visit root_path
      find('button[title="Notifications"]').click
      find('.notifications-list-item span.mdi-close').click
    end

    it "shows a 'no notifications to show' message" do
      expect(page).to have_content('No notifications to show.')
    end
  end

  context "when the user clicks on 'clear all'" do
    before do
      sign_in notification.receiver
      visit root_path
      find('button[title="Notifications"]').click
      find('.notification-dropdown-container .clear-all').click
    end

    it "shows a 'no notifications to show' message" do
      expect(page).to have_content('No notifications to show.')
    end
  end

  context 'when the user clicks on the notification icon twice' do
    before do
      sign_in notification.receiver
      visit root_path
      2.times { find('button[title="Notifications"]').click }
    end

    it 'expands and collapses the notification dropdown menu' do
      expect(page).not_to have_css('notification-dropdown-container')
    end
  end
end
