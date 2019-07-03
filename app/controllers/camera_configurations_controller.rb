require 'gphoto2'

class CameraConfigurationsController < ApplicationController
  def new

  end

  def create
    begin
      retry_count = 0
      camera = GPhoto2::Camera.all.first
      camera.update(iso: desired_iso)
      camera.close

      redirect_to events_path, notice: 'Updated camera'
    rescue => error
      puts error
      camera.close
      retry_count += 1

      if retry_count < 3
        retry
      end

      puts error.inspect
      redirect_to events_path, notice: 'Could not update cameara'
    end

  end

  private

  def desired_iso
    iso_params["iso"].to_i
  end

  def iso_params
    params.permit(:iso)
  end
end
