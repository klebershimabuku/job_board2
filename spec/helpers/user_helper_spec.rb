require 'spec_helper'

describe 'gravatar_for' do
  let(:user) { FactoryGirl.build(:user) }

  it 'should return an image tag for the user with its name as alt' do
    helper.gravatar_for(user).should =~ /img.*alt="#{user.name}"/
  end

  it 'should be able to specify its size' do
    helper.gravatar_for(user, size: "100x100").should =~ /width="100"/
    helper.gravatar_for(user, size: "100x50").should =~ /height="50"/
  end

  it 'should not have width and height specified if no size is given' do
    helper.gravatar_for(user).should_not =~ /width/
    helper.gravatar_for(user).should_not =~ /height/
  end

  it 'src attribute should be from gravatar.com' do
    helper.gravatar_for(user).match(/^http:\/\/gravatar.com\/avatar\/\w{32}\+\.+png$/i)
  end
end
