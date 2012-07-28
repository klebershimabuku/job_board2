# encoding: utf-8
class ValidProvinceValidator < ActiveModel::EachValidator

  PREFECTURES = %w[aichi-ken akita-ken aomori-ken chiba-ken ehime-ken fukui-ken
                  fukuoka-ken fukushima-ken gifu-ken gunma-ken hiroshima-ken
                  hokkaido-ken hyogo-ken ibaraki-ken ishikawa-ken iwate-ken
                  kagawa-ken kanagawa-ken kagoshima-ken kochi-ken kumamoto-ken
                  kyoto-fu mie-ken miyagi-ken miyazaki-ken nagano-ken nagasaki-ken
                  nara-ken niigata-ken oita-ken okayama-ken okinawa-ken
                  osaka-fu saga-ken saitama-ken shiga-ken shimane-ken shizuoka-ken
                  tochigi-ken tokushima-ken tokyo-to tottori-ken toyama-ken wakayama-ken
                  yamagata-ken yamaguchi-ken yamanashi-ken]

  
  def validate_each(record, attribute, value)
   
    value = value.split(',') if !value.nil?
    @found = false
    
    if value.kind_of? Array
      value.each do |v| 
        if PREFECTURES.include?(v.downcase)
          @found = true
        end
      end
    end
    
    
    record.errors.add(attribute, "precisa conter uma província válida") if !@found
  end
end