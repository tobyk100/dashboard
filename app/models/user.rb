class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login

  has_many :user_levels
  has_many :followers
  has_many :followeds, :class_name => 'Follower', :foreign_key => 'student_user_id'

  has_many :students, through: :followers, source: :student_user
  has_many :teachers, through: :followeds, source: :user

  validates_format_of :email, with: Devise::email_regexp, on: :create
  #validates_length_of :first_name, maximum: 35
  #validates_length_of :last_name, maximum: 35
  validates_length_of :name, maximum: 70
  validates_length_of :email, maximum: 255
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true
  validates_length_of :parent_email, maximum: 255
  validates_length_of :username, within: 5..20
  validates_format_of :username, with: /\A[a-z0-9\-\_\.]+\z/i, on: :create

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    'manual' != provider
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['username = :value OR email = :value', { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def levels_from_script(script)
    ul_map = self.user_levels.includes({level: :game}).index_by(&:level_id)
    script.script_levels.includes({ level: :game }, :script).order(:chapter).each do |sl|
      ul = ul_map[sl.level_id]
      sl.user_level = ul
    end
  end

  def next_untried_level(script)
    ScriptLevel.find_by_sql(<<SQL).first
select sl.*
from script_levels sl
left outer join user_levels ul on ul.level_id = sl.level_id and ul.user_id = #{self.id}
where sl.script_id = #{script.id} and (ul.stars is null or ul.stars = 0)
order by sl.chapter
limit 1
SQL
  end

  def progress(script)
    self.connection.select_one(<<SQL)
select count(case when ul.stars > 0 then 1 else null end) as current, count(*) as max
from script_levels sl
left outer join user_levels ul on ul.level_id = sl.level_id and ul.user_id = #{self.id}
where sl.script_id = #{script.id}
SQL
  end
end
