require 'spec_helper'

describe 'RSS Feeds' do
  subject { page }

  context 'Post Feeds' do
    before { visit '/posts/feeds.rss' }
    it { should have_content('Feeds do ShigotoDoko') }
  end
end