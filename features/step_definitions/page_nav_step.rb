Given("The user is on the {string} page") do | view |
  visit(root_path) if view.eql?('home')
  visit(settings_index_path) if view.eql?('Account Settings')
  visit(login_index_path) if view.eql?('Sign In')
end

Given("The user is signed in") do
  @user = create(:user)
  visit "/auth/:twitter/callback"
end

When("They click on {string}") do | clicked |
  click_link 'settings' if clicked.eql?('Settings')
  click_link 'metrics' if clicked.eql?('Metrics')
  click_link 'sign_out' if clicked.eql?('Sign Out')
  click_link 'custom_friends' if clicked.eql?('Custom Friends')
  click_link 'accounts' if clicked.eql?('Accounts')
  click_link 'messages' if clicked.eql?('Messages')
end

Then("They should be redirected to the {string} page") do | view |
  expect(page).to have_content('Account Settings') if view.eql?('Account Settings')
  expect(page).to have_content('Account Metrics') if view.eql?('Account Metrics')
  expect(page).to have_content('Login') if view.eql?('Sign In')
  expect(page).to have_content('Custom Friends Page') if view.eql?('Custom Friends')
  expect(page).to have_content('Feed') if view.eql?('Feed')
  expect(page).to have_content('Social Media Accounts') if view.eql?('Accounts')
  expect(page).to have_content('Direct Messages') if view.eql?('Direct Messages')
end
