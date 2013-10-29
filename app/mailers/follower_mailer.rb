class FollowerMailer < ActionMailer::Base
  default from: 'noreply@code.org'

  def invite_student(teacher, student)
    @teacher = teacher

    mail to: student.email, subject: I18n.t('follower.mail.invite_student.subject')
  end

  def invite_new_student(teacher, student_email)
    @teacher = teacher

    mail to: student_email, subject: I18n.t('follower.mail.invite_student.subject')
  end
end
