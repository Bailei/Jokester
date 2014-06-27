class RendersController < ApplicationController
   class InfoFeed
     attr_accessor :id, :name, :script, :image_url, :created_at, :good_num, :bad_num, :comment_num
     def initialize(id, name, script, image_url, created_at, good_num, bad_num, comment_num)
       @id = id
       @name = name
       @script = script
       @image_url = image_url
       @created_at = created_at
       @good_num = good_num
       @bad_num = bad_num
       @comment_num = comment_num
     end
   end 

   def home
      @episode_feed_items = Episode.all
      @statistic_feed_items = Statistic.all
      @feed_items = []
      tmp = 0
      @episode_feed_items.each do |item|
        infoFeed = InfoFeed.new(item.id, item.name, item.script, 
             item.image_url, item.created_at, @statistic_feed_items[tmp].good_num,
             @statistic_feed_items[tmp].bad_num, @statistic_feed_items[tmp].comment_num)
        @feed_items.push(infoFeed)
        tmp = tmp + 1
      end
    end
   
   def estimate
     id = params[:id]
     es = params[:es]
     statistic = Statistic.find(id)
     num = 0
     if es == "good"
      puts '1111111111111111111111'
      puts statistic.good_num.class
      statistic.good_num = statistic.good_num + 1
      num = statistic.good_num
     else
      statistic.bad_num = statistic.bad_num + 1
      num = statistic.bad_num
     end
     statistic.save
     respond_to do |format|
       res = {:num => num}
       format.json {render :json=>res}
     end 
  end

  def dashboard
    @episode_id = params[:episode_id]
    episode = Episode.find(@episode_id)
    statistic = Statistic.find(@episode_id)
    @feed_item = InfoFeed.new(@episode_id, episode.name, episode.script,
        episode.image_url, episode.created_at, statistic.good_num,
        statistic.bad_num, statistic.comment_num)
    @all_comments = []
    Comment.all.each do |com|
      if "#{com.episode_id}" == @episode_id
        @all_comments.push(com)
      end
    end
  end

  def produce
    episode_id = params[:episode_id]
    content = params[:comment][:content]
    name = params[:comment][:name]
    @comment = Comment.new({:episode_id=>episode_id, :name=>name ,:content=>content})
    tmp1 = @comment.save
    @stat = Statistic.find(episode_id)
    @stat.comment_num = @stat.comment_num + 1
    tmp2 = @stat.save
    #redirect_to "/renders/dashboard?episode_id=#{episode_id}"
    respond_to do |format|
      if tmp1 && tmp2
        format.html {render :action=>"dashboard"}
        format.js
      else
        format.html {render :action=>"dashboard"}
        format.js
      end
    end
  end
end