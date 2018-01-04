module PostInteractors
  class NotifyAwaitingPosts
    include Interactor

    def call
      notifiable_posts = Post.notifiable
      if notifiable_posts.any?
        notifiable_posts.each do |post|
          PostInteractors::Notify.call(post: post)
        end
      else
        context.fail!
      end
    end
  end
end
