namespace :db do
  namespace :promote do 
    task publishers: :environment do

      @file = File.open('db/announcers.json')
      parsed_json = ActiveSupport::JSON.decode(@file)

      parsed_json.each do |data|
        @id              = data['id']
        @user = User.find(@id)
        @user.promote_to_publisher!
      end
    end
  end

  namespace :publish do 
    task online_jobs: :environment do

      @file = File.open('db/published_jobs.json')
      parsed_json = ActiveSupport::JSON.decode(@file)

      parsed_json.each do |data|
        @id              = data['id']
        @post = Post.find(@id)
        @post.publish!
      end
    end
  end

end
