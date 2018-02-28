Then("They should see an option for {string}") do |option|
  expect(page).to have_content("Social Media Accounts") if option.eql?("Social Media Accounts")
end
