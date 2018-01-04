class SubscribersController < ApplicationController
  def new; end

  def create
    @result = false
    @message = nil
    subscriber = Subscriber.find_by(email: subscriber_params[:email])
    if subscriber
      if subscriber.opted_out?
        subscriber.opt_in
        @result = true
      else
        @result = false
        @message = 'Bu e-posta adresine tanımlı bir abonelik bulunmaktadır. Farklı bir e-posta adresi kullanarak tekrar deneyebilirsiniz.'
      end
    else
      new_subscriber = Subscriber.create(subscriber_params)
      if new_subscriber && !new_subscriber.errors.any?
        @result = true
      else
        @result = false
        @message = 'Lütfen form alanlarını doğru bir şekilde doldurarak tekrar deneyin.'
      end
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
