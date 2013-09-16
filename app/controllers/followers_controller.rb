class FollowersController < ApplicationController
  check_authorization except: :accept
  load_and_authorize_resource except: :accept
  before_filter :authenticate_user!

  def index
    @students = current_user.students.select(<<SELECT)
users.*,
(select count(*) from user_levels where user_id = users.id) as levels_finished,
(select max(created_at) from user_levels where user_id = users.id) as last_attempt
SELECT

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
      @user.save!
      Follower.find_or_create_by_user_id_and_student_user_id!(current_user.id, @user.id)
      redirect_to followers_path, notice: "#{@user.name} added as your student"
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
end