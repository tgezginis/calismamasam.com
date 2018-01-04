module PostInteractors
  class Notify
    include Interactor::Organizer

    organize NotifyEmail, NotifyTwitter, NotifyOnesignal, NotifyFacebook

    def call
      post = context.post
      if post.present? && post.decorate.notifiable?
        super
        post.update_columns(notified_at: Time.current, updated_at: Time.current)
      end
    end
  end
end
