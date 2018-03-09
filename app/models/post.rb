class Post < ApplicationRecord
    validates_presence_of :provider, :content
    belongs_to :user
end
