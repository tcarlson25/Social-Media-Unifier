class MastodonPost < ApplicationRecord
    belongs_to :feed
    
    def self.archive(post)
        where(id: post.id).first_or_create do |ma_post|
          ma_post.id = post.id
          ma_post.username = post.account.username
          ma_post.content = post.content
          ma_post.profile_img = post.account.avatar
          urls = []
          post.media_attachments.each do |attachment|
            urls << attachment.url
          end
          ma_post.imgurls = urls.join(',')
          ma_post.favourites_count = post.favourites_count
          ma_post.reblogs_count = post.reblogs_count
          ma_post.post_made_at = post.created_at
          ma_post.favourited = post.favourited?
          ma_post.reblogged = post.reblogged?
       end
    end
end
