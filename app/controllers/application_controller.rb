class ApplicationController < ActionController::Base
  include LocaleHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # this is needed to avoid devise breaking on email param
  before_filter :configure_permitted_parameters, if: :devise_controller?

  around_filter :with_locale

  protected

  PERMITTED_USER_FIELDS = [:name, :username, :email, :password, :password_confirmation, :locale, :gender, :login,
      :remember_me, :birthday, :school, :full_address, :user_type]

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u| u.permit PERMITTED_USER_FIELDS end
    devise_parameter_sanitizer.for(:sign_up) do |u| u.permit PERMITTED_USER_FIELDS end
    devise_parameter_sanitizer.for(:sign_in) do |u| u.permit PERMITTED_USER_FIELDS end
  end

  def with_locale
    I18n.with_locale(locale) do
      yield
    end
  end

  def milestone_response(options)
    response = {}
    script_level = options[:script_level]
    level = script_level.level
    # figure out the previous level
    previous_level = script_level.previous_level
    if previous_level
      response[:previous_level] = build_script_level_path(previous_level)
    end

    # if they solved it, figure out next level
    if options[:solved?]
      response[:total_lines] = options[:total_lines]

      trophy_updates = options.fetch(:trophy_updates, [])
      if trophy_updates.length > 0
        response[:trophy_updates] = trophy_updates
      end

      next_level = script_level.next_level
      # If this is the end of the current script
      if !next_level
        # If the current script is hour of code, continue on to twenty-hour
        if script_level.script.hoc?
          next_level = ScriptLevel.find_by_script_id_and_chapter(Script.find_twenty_hour_script.id, script_level.chapter + 1)
          redirect = current_user ? build_script_level_path(next_level) : "http://code.org/api/hour/finish"
        end
        # Get the wrap up video
        video = script_level.script.wrapup_video
        response[:video_info] = { src: youtube_url(video.youtube_code),  key: video.key, name: data_t('video.name', video.key), redirect: redirect} if video
        response[:message] = 'no more levels'
      end
      # Get the next_level setup
      if next_level
        response[:redirect] = build_script_level_path(next_level)

        if (level.game_id != next_level.level.game_id)
          response[:stage_changing] = {
              previous: { number: level.game_id, name: level.game.name },
              new: { number: next_level.level.game_id, name: next_level.level.game.name }
          }
        end

        if (level.skin != next_level.level.skin)
          response[:skin_changing] = { previous: level.skin, new: next_level.level.skin }
        end
      end
    else
      response[:message] = 'try again'
    end
    response
  end

  def current_user
    if Rails.configuration.minimal_mode
      nil
    else
      super
    end
  end

  def nonminimal
    render 'shared/overloaded', status: 502 if Rails.configuration.minimal_mode
  end

end
