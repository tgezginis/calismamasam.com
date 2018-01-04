class PostDecorator < Draper::Decorator
  delegate_all

  def active?
    object.is_active? && object.published_at < Time.current
  end

  def notifiable?
    object.is_active? && object.notified_at.nil? && object.published_at > 5.minutes.ago && object.published_at < Time.current + 5.minutes && Rails.env.production?
  end

  def job_and_company
    company.present? ? "#{job_title} @ #{company}" : job_title
  end
end
