require 'nokogiri'
require 'custom_exceptions'

class Agency

  def initialize(arg)
    @arg = arg
    @file = arg.gsub(/-/,'_')
  end

  def valid_prefecture?
    prefectures = ['aichi-ken','akita-ken','aomori-ken','chiba-ken','ehime-ken','fukui-ken',
                    'fukuoka-ken','fukushima-ken','gifu-ken','gunma-ken','hiroshima-ken',
                    'hokkaido-ken','hyogo-ken','ibaraki-ken','ishikawa-ken','iwate-ken',
                    'kagawa-ken','kanagawa-ken','kagoshima-ken','kochi-ken', 'kumamoto-ken',
                    'kyoto-fu','mie-ken', 'miyagi-ken', 'miyazaki-ken', 'nagano-ken',
                    'nagasaki-ken', 'nara-ken', 'niigata-ken', 'oita-ken', 'okayama-ken',
                    'osaka-fu', 'saga-ken', 'saitama-ken', 'shiga-ken', 'shimane-ken', 
                    'shizuoka-ken', 'tochigi-ken', 'tokushima-ken', 'tokyo-to', 'tottori-ken',
                    'toyama-ken', 'wakayama-ken', 'yamagata-ken', 'yamaguchi-ken',
                    'yamanashi-ken']
    prefectures.include?(@arg)
  end

  def find_offices

    if valid_prefecture?
      @doc = Nokogiri::XML(open("db/agencies/#{@file}.xml"))
    else
      raise CustomExceptions::InvalidPrefecture
    end

    @entries = @doc.xpath('//agencies/city').map do |i|
      { 'name' => i.xpath('name').inner_text, 'reception' => i.xpath('reception').inner_text, 'address' => i.xpath('address').inner_text, 'phone' => i.xpath('phone').inner_text }
    end
  end
end