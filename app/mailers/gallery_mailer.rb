class GalleryMailer < ApplicationMailer
  def notify_admins(gallery)
    return false unless Rails.env.production?
    @gallery = gallery.decorate
    return false if @gallery.is_active?
    email_addresses = User.admins.pluck(:email)
    email_addresses.each do |email_address|
      mail(to: email_address, subject: "Yeni Galeri Eklendi: #{@gallery.title}")
    end
  end
end
