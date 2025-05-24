require "kafka"

class KafkaProducer
  def initialize(topic = "doorkeeper-events")
    brokers = ENV.fetch("KAFKA_BROKERS", "localhost:9092")
    @kafka = Kafka.new(brokers.split(","))
    @topic = topic
  end

  def publish(event, payload)
    message = { event: event, payload: payload, timestamp: Time.now.to_s }.to_json
    @kafka.deliver_message(message, topic: @topic)
  end
end
