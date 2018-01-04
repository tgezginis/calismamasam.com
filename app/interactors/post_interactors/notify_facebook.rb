module PostInteractors
  class NotifyFacebook
    include Interactor

    def call
      post = context.post
      if post.present? && post.decorate.notifiable?
        client = Buffer::Client.new(ENV['FACEBOOK_KEY_ID'])
        client.create_update(
          body: {
            text:
              "Yeni Röportaj Yayında!\n\n#{post.title} - #{post.job_title}\n\nhttps://calismamasam.com/#{post.slug}",
            profile_ids: [
              ENV['FACEBOOK_PROFILE_ID']
            ]
          }
        )
      else
        context.fail!(success: false)
      end
    end
  end
end
