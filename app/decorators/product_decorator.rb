class ProductDecorator < Draper::Decorator
  delegate_all

  def name_with_brand
    object&.name == object&.brand&.name ? object&.name : "#{object&.brand&.name} #{object&.name}"
  end
end
