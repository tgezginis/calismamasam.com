class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :company, :job_title, :slug, :video_url, :twitter_url, :image, :description, :body, :published_at

  def published_at
    object.published_at.strftime("%d.%m.%Y %H:%S")
  end

  def image
    object.image(:full)
  end

  def body
    Markdown.new(object.body).to_html
  end
end
