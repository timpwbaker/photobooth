class PrintsController < ApplicationController
  def index
    puts cmd
    system cmd
    flash[:notice] = 'Printing, please wait'
    redirect_to new_event_shoot_path(shoot.event.id)
  end

  def shoot
    @_shoot ||= Shoot.find(params[:shoot_id])
  end

  def filename
    Rails.root.join('pdfs', "#{shoot.id}.pdf")
  end

  def cmd
    "lp -o landscape -o page-border=none -o media=\"Postcard.Fullbleed\" #{filename}"
  end
end
