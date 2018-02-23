Given("The user is on the sign in page") do
    visit root_path
end

When("The user clicks Sign in to Twitter") do
  click_on "Sign in"
end

Then("The user should be signed in") do
  expect(user).to have_content("Signed in")
end