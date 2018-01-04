# encoding: UTF-8

author = 'Tolga Gezginiş'

xml.instruct!
xml.rss 'xmlns:media' => 'http://search.yahoo.com/mrss/', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :version => '2.0' do
  xml.channel do
    xml.title Settings.title
    xml.description Settings.description
    xml.link 'https://calismamasam.com'
    xml.language 'tr'
    xml.pubDate Post.active.last.published_at.to_s(:rfc822)
    xml.lastBuildDate Post.active.last.published_at.to_s(:rfc822)

    for post in @posts
      xml.item do
        if post.title
          xml.title post.title
        else
          xml.title ''
        end
        xml.author author
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link 'https://calismamasam.com/' + post.to_param
        xml.guid post.id

        text = markdown(post.body).gsub('href="/', 'href="https://calismamasam.com/')
        if post.image.exists?
          image_url = post.image(:full)
          image_caption = post.title
          image_align = 'center'
          image_tag = "
          <p><img src='" + image_url + "' alt='" + image_caption + "' title='" + image_caption + "' align='" + image_align + "' /></p>
          "
          text = image_tag + text
        end
        xml.description '<p>' + text + '</p>'

        xml.itunes :author, author
        xml.itunes :subtitle, truncate(text, length: 150)
        xml.itunes :summary, text
        xml.itunes :explicit, 'no'
      end
    end
  end
end
