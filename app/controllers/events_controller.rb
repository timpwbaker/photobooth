require 'gphoto2'

class EventsController < ApplicationController
  def index
    cameras = GPhoto2::Camera.all

    camera = cameras.first
    file = camera.capture
    file.save('/tmp/out.jpg')

    puts file
    camera.close
  end

  def new
    @event = Event.new
  end


  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def show
    @event = event
  end

  private

  def event
    Event.find params[:id]
  end

  def event_params
    params.require(:event).permit(:name)
  end
end
