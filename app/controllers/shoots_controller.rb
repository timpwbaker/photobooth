require 'gphoto2'

class ShootsController < ApplicationController
  SIZE = "0"

  def index
    @shoots = Shoot.where(event: params[:event_id])
  end

  def show
    @shoot = shoot
    # path = Rails.root.join('pdfs', "#{@shoot.id}.pdf")
    # pdf = ApplicationController.render(
    #   format: :pdf,
    #   pdf: "foobarbaz",
    #   template: 'shoots/showpdf',
    #   :formats => [:html],
    #   show_as_html: params.key?('debug'),
    #   locals: { shoot: @shoot},
    #   :page_height => '148mm',
    #   :page_width => '100mm',
    #   javascript_delay: 1,
    #   margin:{top:      "0mm",
    #           bottom:   "0mm",
    #           left:     "0mm",
    #           right:    "0mm" })
    # File.open(path, 'wb') { |file| file.write(pdf) }

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'file_name',
          format: :pdf,
          pdf: "foobarbaz",
          template: 'shoots/showpdf',
          :formats => [:html],
          show_as_html: params.key?('debug'),
          locals: { shoot: @shoot},
          :page_height => '148mm',
          :page_width => '100mm',
          javascript_delay: 1,
          margin:{top:      "0mm",
                  bottom:   "0mm",
                  left:     "0mm",
                  right:    "0mm" }
      end
    end
  end

  def new
    @event = event
    @shoot = event.shoots.build
  end


  def create
    @shoot = event.shoots.create

      cameras = GPhoto2::Camera.all
      camera = cameras.first
    begin
      (1..4).each do |n|
        sleep(2)
        file = camera.capture
        location = file.save("app/assets/images/#{image_name(n)}")
        persisted = File.open("app/assets/images/#{image_name(n)}")
        image = @shoot.images.create
        image.image = persisted
        image.save
      end

      camera.close
    rescue => error
      puts error.inspect
      camera.close
    end

    if @shoot.save
      path = Rails.root.join('pdfs', "#{@shoot.id}.pdf")
      pdf = ApplicationController.render(
        format: :pdf,
        pdf: "foobarbaz",
        template: 'shoots/showpdf',
        :formats => [:html],
        show_as_html: params.key?('debug'),
        locals: { shoot: @shoot},
        :page_height => '148mm',
        :page_width => '101mm',
        javascript_delay: 1,
        margin:{top:      "0mm",
                bottom:   "0mm",
                left:     "0mm",
                right:    "0mm" })
      File.open(path, 'wb') { |file| file.write(pdf) }


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
