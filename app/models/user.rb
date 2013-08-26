class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_levels

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
end
