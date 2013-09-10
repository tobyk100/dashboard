class FollowerMailer < ActionMailer::Base
  default from: 'noreply@code.org'

  def invite_student(teacher, student)
    @teacher = teacher

    mail to: student.email, subject: "Join #{teacher.name}'s class at Code.org!"
  end

  def invite_new_student(teacher, student_email)
    @teacher = teacher

    mail to: student_email, subject: "Join #{teacher.name}'s class at Code.org!"
  end
end
