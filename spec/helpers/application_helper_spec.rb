require 'spec_helper'

describe "Flash message helper method" do

  it "should return an flash notice" do
    helper.flash_class('notice'.to_sym).should eql("alert alert-info")
  end

  it "should return an flash success" do
    helper.flash_class('success'.to_sym).should eql("alert alert-success")
  end

  it "should return an flash error" do
    helper.flash_class('error'.to_sym).should eql("alert alert-error")
  end

  it "should return an flash alert" do
    helper.flash_class('alert'.to_sym).should eql("alert alert-error")
  end 
end