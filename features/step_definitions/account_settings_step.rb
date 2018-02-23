Given("The user is on the {string} page") do | view |
  visit(feed_index_path) if view.eql?('home')
end

When("They click on {string}") do | clicked |
  click_link "settings" if clicked.eql?('Settings')
  click_link "metrics" if clicked.eql?('Metrics')
  click_link "sign_out" if clicked.eql?('Sign Out')
end

Then("They should be redirected to the {string} page") do | view |
  expect(page).to have_content("Account Settings") if view.eql?('Account Settings')
  expect(page).to have_content("Account Metrics") if view.eql?('Account Metrics')
  expect(page).to have_content("Login") if view.eql?('Login')
end

Then("They should see an option for {string}") do |option|
  expect(page).to have_content("Social Media Accounts") if option.eql?("Social Media Accounts")
  expect(page).to have_content("Custom Friends") if option.eql?("Custom Friends")
end
