Given("The user is on the {string} page") do | page |
  visit '/feed/index' if page.eql?('home')
end

When("They click on {string}") do | arg |
  click_on "Account Settings" if arg.eql?('Account Settings')
end

Then("They should be redirected to the {string} page") do | page |
  expect(page).to have_content("Account Settings") if page.eql?('Account Settings')
end