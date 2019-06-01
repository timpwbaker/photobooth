require 'gphoto2'

class ShootsController < ApplicationController
  def index
    @shoots = Shoot.where(event: params[:event_id])
  end

  def show
    @shoot = shoot
    respond_to do |format|
      format.html
      format.pdf do
        render(
          format: :pdf,
          pdf: "foobarbaz",
          template: 'shoots/showpdf',
          :formats => [:html],
          show_as_html: params.key?('debug'),
          locals: { shoot: @shoot},
          :page_height => '156mm',
          :page_width => '105mm',
          javascript_delay: 1,
          margin:{top:      "0mm",
                  bottom:   "0mm",
                  left:     "0mm",
                  right:    "0mm" })
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
        update_status("Ready")
        sleep 3
        update_status("")
        sleep 0.2
        begin
          file = camera.capture
          location = file.save("app/assets/images/#{image_name(n)}")
        rescue
          retry
        end
      end

      update_status("Processing")

      (1..4).each do |n|
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
        :page_height => '156mm',
        :page_width => '105mm',
        javascript_delay: 1,
        margin:{top:      "0mm",
                bottom:   "0mm",
                left:     "0mm",
                right:    "0mm" })
      File.open(path, 'wb') { |file| file.write(pdf) }


  redirect_to event_shoot_path(@shoot.event, @shoot)
    else
      render :new
    end
  end

  def update_status(status)
    ActionCable.server.broadcast(
      "shoot_status_channel",
      status: status
    )
  end


  def image_name(n)
    "#{@shoot.id}_#{n}.jpg"
  end

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
