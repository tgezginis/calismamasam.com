class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    return if user.role == 'user'
    can :access, :rails_admin
    can :dashboard
    can :read, :dashboard

    if user.role? :admin
      can :manage, :all
    elsif user.role? :editor
      can :manage, [Category, Gallery, GalleryImage, Product, ProductBrand, ProductCategory, Post, PostImage]
    elsif user.role? :gallery_editor
      can :manage, [Gallery, GalleryImage]
    end
  end
end
