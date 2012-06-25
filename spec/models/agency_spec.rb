# encoding: utf-8
require 'spec_helper'

describe Agency do

  describe '#valid_prefecture?' do 

    describe 'when valid' do

      before { @agency = Agency.new('aichi-ken')  }

      it { @agency.valid_prefecture?.should be_true }
    end

    describe 'when invalid' do

      before { @agency = Agency.new('invalid')  }

      it { @agency.valid_prefecture?.should be_false }
    end
  end

  describe '#find_offices' do
  end
end