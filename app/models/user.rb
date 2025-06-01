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

  after_commit :publish_user_events, on: [ :update ]

  private

  def publish_user_events
    return if saved_changes.blank?

    if saved_change_to_active?
      event = active ? "user.activated" : "user.deactivated"
      publish_kafka_event(event)
    end

    if saved_change_to_email?
      publish_kafka_event("user.email_changed", {
        previous_email: saved_change_to_email.first,
        new_email: email
      })
    end

    if saved_change_to_name?
      publish_kafka_event("user.name_changed", {
        previous_name: saved_change_to_name.first,
        new_name: name
      })
    end

    if saved_change_to_username?
      publish_kafka_event("user.username_changed", {
        previous_username: saved_change_to_username.first,
        new_username: username
      })
    end

    if saved_change_to_display_name?
      publish_kafka_event("user.display_name_changed", {
        previous_display_name: saved_change_to_display_name.first,
        new_display_name: display_name
      })
    end

    # Add more conditions if needed
  end

  def publish_kafka_event(event_name, extra_payload = {})
    payload = {
      user_id: id,
      email: email,
      name: display_name || name,
      active: active
    }.merge(extra_payload)

    Rails.logger.info "Event #{event_name} raised for #{email}."
    KafkaProducer.new.publish(event_name, payload)
  end
end
