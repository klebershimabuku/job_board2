module PostsHelper

  def link_tags(collection)  
    collection.split(',').collect do |tag| 
      link = ""
      link += link_to tag, tags_filter_post_path(tag)
    end.join(', ').html_safe
  end
end
