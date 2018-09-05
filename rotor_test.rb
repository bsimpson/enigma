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
    expected_output = @rotor.mapping[0]
    output = @rotor.input(0)
    output.must_equal expected_output
  end

  it "input to reflect" do
    @rotor.reflect(@rotor.input(0)).must_equal 0
  end

  it "reflects on reset" do
    val = @rotor.input(0)
    @rotor.increment
    @rotor.reset
    @rotor.reflect(val).must_equal 0
  end

  it "increments position" do
    first_map = @rotor.mapping[0]
    @rotor.increment
    @rotor.position.must_equal 1
    @rotor.mapping[25].must_equal first_map
    @rotor.mapping[0].wont_equal first_map
  end

  it "returns different value" do
    first = @rotor.input(0)
    @rotor.increment
    second = @rotor.input(0)
    @rotor.increment
    third = @rotor.input(0)

    first.wont_equal second
    second.wont_equal third
    third.wont_equal first
  end

  it "calls rollover" do
    first_map = @rotor.mapping[0]
    @rotor.event_handler.expect :rollover!, nil, [@rotor]

    26.times do
      @rotor.increment
    end

    @rotor.position.must_equal 0
    @rotor.mapping[0].must_equal first_map
  end
end
