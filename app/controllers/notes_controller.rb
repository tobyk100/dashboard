class NotesController < ApplicationController
  def index
    @notes = t('slides.' + params[:key])
    # XXX Need to have a parallel "note_paths" hash for a variety of reasons.
    # See config/locales/slides.en.yml for details.
    @note_paths = t('slides.' + params[:key], locale: :en)

    render layout: false
  end
end
