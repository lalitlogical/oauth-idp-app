class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id, dependent: :destroy

  # Optional helper method for distinct apps
  def authorized_applications
    Doorkeeper::Application.where(id: access_tokens.select("distinct application_id"))
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :inactive_account
  end

  after_commit :user_deactivated, if: -> { saved_change_to_active? }

  private

  def user_deactivated
    Rails.logger.info "User active state for email #{email} is #{active}."
    KafkaProducer.new.publish("user_active_state", {
      user_id: id,
      email: email,
      active: active
    })
  end
end
