class User < ActiveRecord::Base


  #-----------------------------------------------
  # 転送するuserを選択する
  #  -> ロジックを作り込むのは、また今度....
  def self.select_forward_to(except_user_id)
    to_user_num = rand(ENV['FWD_MAX_NUM'].to_i) + 1
    users = User.where.not(user_id: except_user_id).where(is_valid: true).sample(to_user_num)
  end
  

  #-----------------------------------------------
  # Create User from auth info by OmniAuth...
  def self.create_with_omniauth(auth)
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SALT'])

    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']

      user.user_id = auth['extra']['user_id']
      user.org_id = auth['extra']['organization_id']
      user.nick_name = auth['extra']['nickname']
      user.email = auth['extra']['email']

      user.instance_url = auth['credentials']['instance_url']

      user.token = crypt.encrypt_and_sign(auth['credentials']['token'])
      user.refresh_token = crypt.encrypt_and_sign(auth['credentials']['refresh_token'])
    end
  end


  #-----------------------------------------------
  # force.comへの接続用clientを生成する
  def create_client_to_force
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SALT'])

    token = crypt.decrypt_and_verify(self.token)
    refresh_token = crypt.decrypt_and_verify(self.refresh_token)

    client = Force.new :instance_url => self.instance_url,
                       :oauth_token => token,
                       :refresh_token => refresh_token,
                       :client_id => ENV['CLIENT_ID'],
                       :client_secret => ENV['CLIENT_SECRET']
    
  end

end
