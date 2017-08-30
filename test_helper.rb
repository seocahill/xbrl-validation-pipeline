module TestHelpers

  def message_levels(response)
    response["log"].map do |message|
      message["level"]
    end
  end
end