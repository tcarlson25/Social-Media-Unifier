Given("The user has archived posts for {string}") do |provider|
   if provider == "Twitter"
        #VCR.use_cassette('javascript_VCR', match_requests_on => [:host]) do
        visit(root_path)
        find(:xpath, '//*[@id="tw_arch_988512257322766336"]').click
        #end
      archived_twitter_posts = TwitterPost.new( id: "ID",
                                                name: "Name",
                                                username: "Username",
                                                content: "Content",
                                                profile_img: "profile_img",
                                                favorite_count: "favorite_count",
                                                retweet_count: "retweet_count",
                                                post_made_at: "post_made_at",
                                                favorited: "favorited",
                                                retweeted: "retweeted") 
                                                
   end
end

Then("The user should see their {string} posts") do |provider|
    expect(page.status_code).to be(200) 
end