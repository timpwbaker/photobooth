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

    camera = GPhoto2::Camera.all.first

    if !camera
      flash[:notice] = "Could not find camera"
      redirect_to new_event_shoot_path(@shoot.event.id) and return
    end


    begin
      update_status("Camera in black square", "⇧", "green", "white", 160)
      sleep 3
      (1..4).each do |n|
        retry_count = 0
        update_status("", "", "green", "white", 160)
        sleep 1
        update_status(3, "", "green", "white", 300)
        sleep 0.5
        update_status(2, "", "green", "white", 300)
        sleep 0.5
        update_status(1, "", "green", "white", 300)
        sleep 0.5
        update_status("Pose", "", "green", "white", 300)
        sleep 0.5
        update_status("", "", "white", "green", 300)
        begin
          file = camera.capture
          location = file.save("app/assets/images/#{image_name(n)}")
        rescue => error
          puts error
          retry_count += 1

          if retry_count < 3
            retry
          end

          puts error.inspect
          camera.close
          flash[:notice] = "Could not capture image"
          redirect_to new_event_shoot_path(@shoot.event.id) and return
        end
      end

      update_status("Processing", "", "green", "white", 160)

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

  def update_status(status, secondary_status, background, remove_background, font_size)
    ActionCable.server.broadcast(
      "shoot_status_channel",
      status: status,
      secondary_status: secondary_status,
      font_size: font_size,
      background: background,
      remove_background: remove_background
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
