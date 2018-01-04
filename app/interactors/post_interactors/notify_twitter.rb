module PostInteractors
  class NotifyTwitter
    include Interactor

    def call
      post = context.post
      if post.present? && post.decorate.notifiable?
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
          config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
        end
        if post.twitter_url
          client.update("Yeni Röportaj Yayında!\n\n#{post.title} - #{post.job_title} - @#{post.twitter_url.gsub('https://twitter.com/', '')}\n\nhttps://calismamasam.com/#{post.slug}")
        else
          client.update("Yeni Röportaj Yayında!\n\n#{post.title} - #{post.job_title}\n\nhttps://calismamasam.com/#{post.slug}")
        end
      else
        context.fail!(success: false)
      end
    end
  end
end
