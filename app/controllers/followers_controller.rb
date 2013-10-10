class FollowersController < ApplicationController
  check_authorization except: :accept
  load_and_authorize_resource except: :accept
  before_filter :authenticate_user!

  def index
    script = Script.first
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
          redirect_to redirect_url, notice: 'Invite sent'
        else
          FollowerMailer.invite_new_student(current_user, key).deliver
          redirect_to redirect_url, notice: 'Invite sent'
        end
      else
        student = User.find_by_username(key)
        if student
          # todo: queue invite for user if no email
          FollowerMailer.invite_student(current_user, student).deliver
          redirect_to redirect_url, notice: 'Invite sent'
        else
          redirect_to redirect_url, notice: "Username '#{key}' not found"
        end
      end
    elsif params[:teacher_email]
      target_user = User.find_by_email(params[:teacher_email])

      if target_user
        Follower.create!(user: target_user, student_user: current_user)

        redirect_to redirect_url, notice: "#{target_user.name} added as your teacher"
      else
        redirect_to redirect_url, notice: "Could not find anyone signed in with '#{params[:email]}'. Please ask them to sign up here and then try adding them again"
      end
    else
      raise "unknown use"
    end
  end

  def create_student
    student_params = params[:user].permit([:username, :password, :gender, :birthday, :parent_email])
    raise "no student data posted" if !student_params

    @user = User.new(student_params)

    if User.find_by_username(@user.username)
      @user.errors.add(:username, "#{@user.username} is already taken, please pick another")
    else
      @user.provider = 'manual'
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
    section = Section.find(params[:section_id])
    raise "not owner of that section" if section.user_id != current_user.id

    Follower.connection.execute(<<SQL)
update followers
set section_id = #{section.id}
where id in (#{params[:follower_ids].map(&:to_i).join(',')})
  and user_id = #{current_user.id}
SQL
    redirect_to manage_followers_path, notice: "Updated class assignments"
  end
end