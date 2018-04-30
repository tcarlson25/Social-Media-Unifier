require 'rails_helper'

RSpec.describe MastodonPost, type: :model do
  
  describe '#archive' do
    it 'creates a MastodonPost object from post data' do
      mastodon_post = Mastodon::Status.new({
        'id' => 1,
        'content' => 'post_content',
        'favourites_count' => 3,
        'reblogs_count' => 2,
        'favourited' => true,
        'reblogged' => true,
        'created_at' => 'time_stamp'
      })
      allow(mastodon_post).to receive_message_chain(:account, :username).and_return('user_username')
      allow(mastodon_post).to receive_message_chain(:account, :avatar).and_return('user_avatar')
      allow(mastodon_post).to receive(:media_attachments).and_return([])
      returned_post = MastodonPost.archive(mastodon_post)
      expect(returned_post.id).to eql('1')
      expect(returned_post.username).to eql('user_username')
      expect(returned_post.content).to eql('post_content')
      expect(returned_post.profile_img).to eql('user_avatar')
      expect(returned_post.favourites_count).to eql(3)
      expect(returned_post.reblogs_count).to eql(2)
      expect(returned_post.post_made_at).to eql('time_stamp')
      expect(returned_post.favourited?).to eql(true)
      expect(returned_post.reblogged?).to eql(true)
    end
  end
  
end
