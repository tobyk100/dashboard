class NotesController < ApplicationController
  include LocaleHelper
  def index
    filename = "config/notes/" + js_locale + "/" + params[:code] + ".md"
    if File.exists?(filename)
      markdown = File.read(filename)
      html = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        :hard_wrap => true
      ).render(markdown)
      render text: html
    else
      render text: t('reference_area.no_notes')
    end
  end
end
