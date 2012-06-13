# == Schema Information
#
# Table name: contact_infos
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
require 'spec_helper'

describe ContactInfo do
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :user_id }
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
end

