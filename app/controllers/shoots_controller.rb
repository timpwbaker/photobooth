require 'gphoto2'

class ShootsController < ApplicationController

  def show
    @shoot = shoot
  end

  def new
    GPhoto2::Camera.first do |camera|
      begin
        camera.update(autofocusdrive: true)
      rescue GPhoto2::Error
        puts "autofocus failed... retrying"
        camera.reload
        retry
      ensure
        camera.update(autofocusdrive: false)
      end
    end

    GPhoto2::Camera.first do |camera|
      begin

        File.delete("app/assets/images/live_view.mjpg") if File.exist?("app/assets/images/live_view.mjpg")
        File.binwrite('app/assets/images/live_view.mjpg', camera.preview.data)

        camera.close
      rescue => error
        puts error.inspect
        camera.close
      end

      @event = event
      @shoot = event.shoots.build
    end
  end


  def create
    @shoot = event.shoots.create

    begin
      cameras = GPhoto2::Camera.all
      camera = cameras.first

      (1..4).each do |n|
        sleep(2)
        file = camera.capture
        file.save("app/assets/images/#{image_name(n)}")
        @shoot.send("image#{n}=", image_name(n))
      end

      puts file
      camera.close
    rescue => error
      puts error.inspect
      camera.close
    end

    if @shoot.save
      redirect_to event_shoot_path(@shoot.event, @shoot), notice: 'Shoot was successfully created.'
    else
      render :new
    end
  end

  # def check_directory_exists
  #   FileUtils.mkdir_p "#{base_directory}/#{shoot_directory}"
  # end

  # def shoot_directory
  #   "events/#{event_id}/shoot_#{@shoot.id}"
  # end

  def image_name(n)
    "#{@shoot.id}_#{n}.jpg"
  end

  # def base_directory
  #   "#{Rails.root}/public/images"
  # end

  def shoot
    Shoot.find params[:id]
  end

  def event_id
    params[:event_id]
  end

  def event
    Event.find event_id
  end
end
