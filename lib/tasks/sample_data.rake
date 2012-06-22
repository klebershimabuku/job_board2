namespace :db do
  namespace :populate do 
    desc "Fill database with sample data"
    task users: :environment do

      puts 'creating admin user..'
      User.create!(name: "Kleber Shimabuku",
                   email: "klebershimabuku@gmail.com",
                   password: "foobar",
                   password_confirmation: "foobar",
                   role: "admin")

      User.create!(name: "Marcelo Mogami",
                   email: "marcelomogami@gmail.com",
                   password: "foobar",
                   password_confirmation: "foobar",
                   role: "admin")

      puts 'creating sample users..'
      99.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password  = "password"
        User.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password)
      end
    end

    task prefectures: :environment do 
    desc 'populating prefectures..'

      prefectures = %w[aichi-ken akita-ken aomori-ken chiba-ken ehime-ken fukui-ken
                      fukuoka-ken fukushima-ken gifu-ken gunma-ken hiroshima-ken
                      hokkaido-ken hyogo-ken ibaraki-ken ishikawa-ken iwate-ken
                      kagawa-ken kanagawa-ken kagoshima-ken kochi-ken kumamoto-ken
                      kyoto-fu mie-ken miyagi-ken miyazaki-ken nagano-ken nagasaki-ken
                      nara-ken niigata-ken oita-ken okayama-ken okinawa-ken
                      osaka-fu saga-ken saitama-ken shiga-ken shimane-ken shizuoka-ken
                      tochigi-ken tokushima-ken tokyo-to tottori-ken toyama-ken wakayama-ken
                      yamagata-ken yamaguchi-ken yamanashi-ken]

      prefectures.each do |p|
        Prefecture.create!(name: p.capitalize)
      end
    end
  end
end