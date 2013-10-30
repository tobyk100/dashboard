class NotesController < ApplicationController
  def index
    @notes = t('slides.' + params[:key])

    render layout: false
  end
end
