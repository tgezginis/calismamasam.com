module PostInteractors
  class NotifyOnesignal
    include Interactor

    def call
      post = context.post
      if post.present? && post.decorate.notifiable?
        OneSignal::OneSignal.user_auth_key = ENV['ONESIGNAL_AUTH_KEY']
        OneSignal::OneSignal.api_key = ENV['ONESIGNAL_API_KEY']
        params = {
          "app_id" => ENV['ONESIGNAL_APP_ID'],
          "template_id" => ENV['ONESIGNAL_TEMPLATE_ID'],
          "url" => "https://calismamasam.com/#{post.slug}",
          "contents" => {"en" => "#{post.title} - #{post.job_title}", "tr" => "#{post.title} - #{post.job_title}"},
          "included_segments" => ["All"]
        }
        OneSignal::Notification.create(params: params)
      else
        context.fail!(success: false)
      end
    end
  end
end
