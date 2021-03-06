require "rails_helper"

RSpec.feature "Notifications", type: :feature do
  given(:photo_path) { Rails.root.join("app", "assets", "images", "icon.png") }
  given(:user) { FactoryBot.create(:user) }
  given(:other) { FactoryBot.create(:user) }

  scenario "come when user is followed " do
    expect do
      sign_in other
      visit user_path(user)
      click_button "フォローする"
      sign_in user
      visit notifications_user_path(user)
    end.to change { Notification.all.size }.by(1)
    expect(page).to have_content "#{other.user_name}からフォローされました"
    within("i.fa-bell") do
      expect(page).to have_content 1
    end
  end
  scenario "come when user's post is liked", js: true do
    @post = user.posts.create
    @post.photos.create(image: Rack::Test::UploadedFile.new(photo_path))
    expect do
      sign_in other
      visit user_path(user)
      page.first(".card-img-top").click
      sleep 1
      page.first(".love").click
      sleep 1
      sign_in user
      visit notifications_user_path(user)
    end.to change { Notification.all.size }.by(1)
    expect(page).to have_content "#{other.user_name}からいいねが届いています"
    within("i.fa-bell") do
      expect(page).to have_content 1
    end
  end
  scenario "come when user's post is commented", js: true do
    @post = user.posts.create
    @post.photos.create(image: Rack::Test::UploadedFile.new(photo_path))
    expect do
      sign_in other
      visit user_path(user)
      page.first(".card-img-top").click
      sleep 1
      fill_in "comment_comment", with: "テストコメント"
      find("#comment_comment").native.send_keys(:return)
      sleep 1
      sign_in user
      visit notifications_user_path(user)
    end.to change { Notification.all.size }.by(1)
    expect(page).to have_content "#{other.user_name}からコメントが届いています"
    within("i.fa-bell") do
      expect(page).to have_content 1
    end
  end
  scenario "come when direct message is given" do
    expect do
      sign_in other
      visit user_path(user)
      click_button "DMを送る"
      fill_in "direct_message_message", with: "テストメッセージ"
      click_button "Create Direct message"
      sign_in user
      visit notifications_user_path(user)
    end.to change { Notification.all.size }.by(1)
    expect(page).to have_content "#{other.user_name}からダイレクトメッセージが届いています"
    within("i.fa-bell") do
      expect(page).to have_content 1
    end
    within("i.fa-envelope") do
      expect(page).to have_content 1
    end
  end
end