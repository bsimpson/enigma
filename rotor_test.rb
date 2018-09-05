require "minitest/autorun"
require "./rotor"

describe Rotor do
  before do
    event_handler = Minitest::Mock.new
    event_handler.expect :increment!, nil

    @rotor = Rotor.new(event_handler: event_handler)
  end

  it "starts at zero" do
    @rotor.position.must_equal 0
  end

  it "maps input" do
    expected_output = @rotor.mapping[1]
    output = @rotor.input(1)
    output.must_equal expected_output
  end

  it "input to reflect" do
    @rotor.reflect(@rotor.input(1)).must_equal 1
  end
end
