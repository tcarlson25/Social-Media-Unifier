Given("The user is on the {string} page") do | view |
  visit(root_path) if view.eql?('home')
  visit(settings_index_path) if view.eql?('Account Settings')
  visit('users/sign_in') if view.eql?('Sign In')
  visit(settings_accounts_path) if view.eql?('Accounts')
  visit(settings_custom_friends_path) if view.eql?('Custom Friends')
  visit(settings_metrics_path) if view.eql?('Metrics')
  visit(feeds_messages_path) if view.eql?('Messages')
  visit(feeds_archives_path) if view.eql?('Archives')
  visit(feeds_notifications_path) if view.eql?('Notifications')
end

When("The user visits the {string} page") do |view|
  visit(feeds_index_path) if view.eql?('home')
  visit(feeds_messages_path) if view.eql?('Messages')
  visit(settings_index_path) if view.eql?('Account Settings')
  visit(settings_metrics_path) if view.eql?('Metrics')
  visit(settings_custom_friends_path) if view.eql?('Custom Friends')
  visit(settings_accounts_path) if view.eql?('Accounts')
  visit(feeds_archives_path) if view.eql?('Archives')
  visit(feeds_notifications_path) if view.eql?('Notifications')
end

When("They click on {string}") do | clicked |
  click_link 'settings' if clicked.eql?('Settings')
  visit settings_metrics_path if clicked.eql?('Metrics')
  click_link 'sign_out' if clicked.eql?('Sign Out')
  click_link 'custom_friends' if clicked.eql?('Custom Friends')
  click_link 'accounts' if clicked.eql?('Accounts')
  click_link 'messages' if clicked.eql?('Messages')
  visit feeds_archives_path if clicked.eql?('Archives')
  click_link 'notifications' if clicked.eql?('Notifications')
end

Then("They should be redirected to the {string} page") do | view |
  expect(page).to have_current_path(settings_index_path) if view.eql?('Account Settings')
  expect(page).to have_current_path(settings_metrics_path) if view.eql?('Account Metrics')
  expect(page).to have_current_path('users/sign_in', only_path: true) if view.eql?('Log In')
  expect(page).to have_current_path(settings_custom_friends_path, only_path: true) if view.eql?('Custom Friends')
  expect(page).to have_current_path(settings_accounts_path, only_path: true) if view.eql?('Accounts')
  
  expect(page).to have_current_path(feeds_index_path, only_path: true) if view.eql?('Feed')
  expect(page).to have_current_path(feeds_messages_path, only_path: true) if view.eql?('Direct Messages')
  expect(page).to have_current_path(feeds_post_path, only_path: true) if view.eql?('Post')
  expect(page).to have_current_path(feeds_archives_path, only_path: true) if view.eql?('Archives')
  expect(page).to have_current_path(feeds_notifications_path, only_path: true) if view.eql?('Notifications')
end
