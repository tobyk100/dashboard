class FollowersController < ApplicationController
  before_filter :authenticate_user!, except: [:student_user_new, :student_register]
  check_authorization only: [:index, :new, :create]
  load_and_authorize_resource only: [:index, :new, :create]

  def index
    script = Script.twenty_hour_script
    @section_map = Hash.new{ |h,k| h[k] = [] }
    students = current_user.followers.includes([:section, { student_user: [{ user_trophies: [:concept, :trophy] }, :user_levels] }])
    students = students.where(['section_id = ?', params[:section_id].to_i]) if params[:section_id].to_i > 0
    students.each do |f|
      @section_map[f.section] << f.student_user
    end

    @all_script_levels = script.script_levels.includes({ level: :game })
    @all_script_levels = @all_script_levels.where(['levels.game_id = ?', params[:game_id].to_i]) if params[:game_id].to_i > 0
    @all_concepts = Concept.all

    @all_games = Game.where(['id in (select game_id from levels l inner join script_levels sl on sl.level_id = l.id where sl.script_id = ?)', script.id])
  end

  def new
  end

  def create
    redirect_url = params[:redirect] || followers_path

    if params[:student_email_or_username]
      key = params[:student_email_or_username]
      if key =~ Devise::email_regexp
        student = User.find_by_email(key)
        if student
          FollowerMailer.invite_student(current_user, student).deliver
          redirect_to redirect_url, notice: I18n.t('follower.invite_sent')
        else
          FollowerMailer.invite_new_student(current_user, key).deliver
          redirect_to redirect_url, notice: I18n.t('follower.invite_sent')
        end
      else
        student = User.find_by_username(key)
        if student
          # todo: queue invite for user if no email
          FollowerMailer.invite_student(current_user, student).deliver
          redirect_to redirect_url, notice: I18n.t('follower.invite_sent')
        else
          redirect_to redirect_url, notice: I18n.t('follower.error.username_not_found', username: key)
        end
      end
    elsif params[:teacher_email_or_code]
      target_section = Section.find_by_code(params[:teacher_email_or_code])
      target_user = target_section.try(:user) || User.find_by_email(params[:teacher_email_or_code])

      if target_user
        begin
          Follower.create!(user: target_user, student_user: current_user, section: target_section)
        rescue ActiveRecord::RecordNotUnique => e
          Rails.logger.error("attempt to create duplicate follower from #{current_user.id} => #{target_user.id}")
        end

        redirect_to redirect_url, notice: I18n.t('follower.added_teacher', name: target_user.name)
      else
        redirect_to redirect_url, notice: I18n.t('follower.error.no_teacher', teacher_email_or_code: params[:teacher_email_or_code])
      end
    else
      raise "unknown use"
    end
  end

  def manage
    @followers = current_user.followers.order('users.name').includes([:student_user, :section])
  end

  def create_student
    student_params = params[:user].permit([:username, :name, :password, :gender, :birthday, :parent_email])
    raise "no student data posted" if !student_params

    @user = User.new(student_params)

    if User.find_by_username(@user.username)
      @user.errors.add(:username, I18n.t('follower.error.username_in_use', username: @user.username))
    else
      @user.provider = User::PROVIDER_MANUAL
      if @user.save
        Follower.find_or_create_by_user_id_and_student_user_id!(current_user.id, @user.id)
        redirect_to followers_path, notice: "#{@user.name} added as your student"
      end
    end
  end

  def accept
    # todo: add a guid/hash to prevent url hacking
    @teacher = User.find(params[:teacher_user_id])

    if Follower.find_by_user_id_and_student_user_id(@teacher, current_user)
      redirect_to(root_path, notice: "#{@teacher.name} already added as a teacher")
      return
    end

    if params[:confirm]
      Follower.create!(user: @teacher.id, student_user: current_user.id)
      redirect_to root_path, notice: "#{@teacher.name} was added as a teacher"
    end
  end

  def add_to_section
    if params[:follower_ids]
      section = Section.find(params[:section_id])
      raise "not owner of that section" if section.user_id != current_user.id

      Follower.connection.execute(<<SQL)
update followers
set section_id = #{section.id}
where id in (#{params[:follower_ids].map(&:to_i).join(',')})
  and user_id = #{current_user.id}
SQL
      redirect_to manage_followers_path, notice: "Updated class assignments"
    else
      redirect_to manage_followers_path, notice: "No students selected"
    end
  end

  def student_user_new
    @section = Section.find_by_code(params[:section_code])

    # make sure section_code is in the path (rather than just query string)
    if request.path != student_user_new_path(section_code: params[:section_code])
      redirect_to student_user_new_path(section_code: params[:section_code])
    end
    @user = User.new
  end

  def student_register
    @section = Section.find_by_code(params[:section_code])
    student_params = params[:user].permit([:username, :name, :password, :gender, :birthday, :parent_email])

    @user = User.new(student_params)

    if current_user
      @user.errors.add(:username, "Please signout before proceeding")
    else
      if User.find_by_username(@user.username)
        @user.errors.add(:username, I18n.t('follower.error.username_in_use', username: @user.username))
      else
        @user.provider = User::PROVIDER_MANUAL
        if @user.save
          Follower.create!(user_id: @section.user_id, student_user: @user, section: @section)
          # todo: authenticate new user
          redirect_to root_path, notice: I18n.t('follower.registered', section_name: @section.name)
          return
        end
      end
    end

    render "student_user_new"
  end
end
