class PrizeMailer < ActionMailer::Base
  default from: 'noreply@code.org'

  def prize_earned(student)
    mail to: student.email, subject: I18n.t('prize_mail.prize_earned.subject')
  end

  def teacher_prize_earned(teacher)
    mail to: teacher.email, subject: I18n.t('prize_mail.teacher_prize_earned.subject')
  end

  def teacher_bonus_prize_earned(teacher)
    mail to: teacher.email, subject: I18n.t('prize_mail.teacher_bonus_prize_earned.subject')
  end
end
