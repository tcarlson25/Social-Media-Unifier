Given("The user has archived posts") do
    #visit(root_path)
    expect(page).to have_current_path(root_path)
    #page.refresh
    save_and_open_page
    #expect(page).to have_selector('.')
    #page.find('.archive_obj.zmdi.zmdi-star-outline.not_archived')
    click_on(first('.archive_logo'))
end

When("They unarchive a post") do
    #save_and_open_page
    #VCR.use_cassette('cucumber_tags/twitter_login_vcr') do
    first('.archive_logo').click
            #tw_post_988958913272909824 > div:nth-child(5) > label.archive_logo
            
            #tw_arch_988970116380610560
        
    #end
end

Then("The archives are empty") do
    #VCR.use_cassette('cucumber_tags/twitter_login_vcr') do
    page.refresh
    #save_and_open_page
    expect(page).not_to have_selector('.archive_logo')
    #end
end

Then("The archives are not empty") do
   page.refresh
   expect(page).to have_selector('.archive_logo')
end

Then("The user should see their {string} posts") do |provider|
    expect(page.status_code).to be(200) 
end