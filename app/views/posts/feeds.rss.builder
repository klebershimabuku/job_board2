xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title 'Feeds do ShigotoDoko'
    xml.description 'A sua referencia de empregos no Japao'
    xml.link posts_url

    for post in @posts 
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end