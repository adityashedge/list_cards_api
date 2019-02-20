module Tokenable
  def generate_auth_token
    auth_token = loop do
      token = SecureRandom.base64(24).tr('+/=', 'Qrt')
      break token unless self.class.where(auth_token: token).exists?
    end
    self.auth_token = auth_token
  end
end
