module PostInteractors
  class NotifyEmail
    include Interactor

    def call
      post = context.post
      if post.present? && post.decorate.notifiable?
        PostMailer.notify_subscribers(post).deliver_now
      else
        context.fail!(success: false)
      end
    end
  end
end
