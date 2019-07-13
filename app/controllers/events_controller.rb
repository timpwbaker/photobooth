require 'gphoto2'

class EventsController < ApplicationController
  def index
    @events = Event.all

    if @events.count == 1
      redirect_to @events.first
    end
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

    redirect_to new_event_shoot_path(@event)
  end

  private

  def event
    Event.find params[:id]
  end

  def event_params
    params.require(:event).permit(:name)
  end
end
