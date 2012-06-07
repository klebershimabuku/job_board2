require 'spec_helper'

describe 'link_tags' do

  tags_1 = 'aichi-ken'
  tags_2 = 'aichi-ken,shizuoka-ken'
  tags_3 = 'aichi-ken,shizuoka-ken,gifu-ken'

  it 'should match aichi-ken' do
    helper.link_tags(tags_1).should == '<a href="/posts/tags/aichi-ken">aichi-ken</a>'
  end

  it 'should match aichi-ken,shizuoka-ken' do 
    helper.link_tags(tags_2).should == '<a href="/posts/tags/aichi-ken">aichi-ken</a>, <a href="/posts/tags/shizuoka-ken">shizuoka-ken</a>'
  end

  it 'should match aichi-ken,shizuoka-ken,gifu-ken' do 
    helper.link_tags(tags_3).should == '<a href="/posts/tags/aichi-ken">aichi-ken</a>, <a href="/posts/tags/shizuoka-ken">shizuoka-ken</a>, <a href="/posts/tags/gifu-ken">gifu-ken</a>'
  end
end

