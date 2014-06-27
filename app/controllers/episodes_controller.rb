class EpisodesController < ApplicationController
    def show
      @episode = Episode.find(params[:id])
      @statistic = Statistic.find(params[:id])
    end
 
    def new
      @episode = Episode.new
      @statistic = Statistic.new
    end

    def create
      name = episode_params[:name]
      script = episode_params[:script]
      image_io = episode_params[:image]
      if image_io != nil
        image_name = Time.new.to_s.split.join("-") + "-" + image_io.original_filename
        image_name = Digest::SHA1.hexdigest image_name
        image_url = Rails.root.join('public', 'images', image_name)
        File.open(image_url, 'wb') do |file|
           file.write(image_io.read)
        end
        new_params = {:name=>name, :script=>script, :image_url=>image_name}
        @episode = Episode.new(new_params)
      else
        new_params = {:name=>name, :script=>script, :image_url=>nil}
        @episode = Episode.new(new_params)
      end
      @statistic = Statistic.new({:good_num=>0, :bad_num=>0, :comment_num=>0})
      if @episode.save && @statistic.save
        redirect_to @episode
      else
         render "new"
      end
    end
   
    private   
      def episode_params
        params.require(:episode).permit(:name, :script, :image)
      end
end