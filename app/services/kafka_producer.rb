require "kafka"

class KafkaProducer
  def initialize(topic = "user_events")
    brokers = ENV.fetch("KAFKA_BROKERS", "localhost:9092")
    @kafka = Kafka.new(brokers.split(","))
    @topic = topic
  end

  def publish(event, payload)
    message = { event: event, producer_service: "idp_app", payload: payload, timestamp: Time.now.to_s }.to_json
    @kafka.deliver_message(message, topic: @topic)
  end
end
