class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id

  # Optional helper method for distinct apps
  def authorized_applications
    Doorkeeper::Application.where(id: access_tokens.select("distinct application_id"))
  end
end
