require 'factory_girl'

ada =
  User.find_by(login: 'ada') ||
    FactoryGirl.create(:user, login: 'ada', institutional_id: '@ada')

FactoryGirl.create(:media_entry, creator_id: ada.id, responsible_user: ada)
