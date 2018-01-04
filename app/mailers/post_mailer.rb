class PostMailer < ApplicationMailer
  def notify_subscribers(post)
    return false unless Rails.env.production?
    @post = post
    subscriber_emails = []
    subscriber_variables = {}
    Subscriber.not_opted_out.each do |subscriber|
      subscriber_emails << subscriber.email
      subscriber_variables[subscriber.email] = {
        subscriber.email => { id: subscriber.id }
      }
    end
    email_addresses = subscriber_emails
    email = mail(to: email_addresses, subject: "Yeni Röportaj: #{@post.title}")
    email.mailgun_recipient_variables = subscriber_variables
  end

  def notify_subscriber(post, subscriber)
    @post = post
    @user = subscriber
    return if @user.opted_out?
    mail(to: @user.email, subject: "Yeni Röportaj: #{@post.title}")
  end
end
