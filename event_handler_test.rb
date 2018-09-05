require "minitest/autorun"
require "./event_handler"
require "./rotor"

describe EventHandler do
  before do
    @event_handler = EventHandler.new
    @rotor_one = Rotor.new(event_handler: @event_handler)
    @rotor_two = Rotor.new(event_handler: @event_handler)
    @rotor_three = Rotor.new(event_handler: @event_handler)
    @event_handler.rotors = [@rotor_one, @rotor_two, @rotor_three]
  end

  it "sets rotors" do
    @event_handler.rotors.must_equal [@rotor_one, @rotor_two, @rotor_three]
  end

  it "increments position on input" do
    @event_handler.input(0)
    @event_handler.rotors.last.position.must_equal 1
  end

  it "rolls over at 26" do
    26.times do
      @event_handler.rotors.last.increment
    end
    @event_handler.rotors.last.position.must_equal 0
  end

  it "increments adjacent rotor" do
    25.times { @event_handler.rotors.last.increment }
    @event_handler.input(0)
    @event_handler.rotors[1].position.must_equal 1
  end

  it "inputs through all rotors" do
    25.times { @event_handler.rotors.last.increment }
    25.times { @event_handler.rotors[1].increment }

    @event_handler.input(0)

    @event_handler.rotors.last.position.must_equal 0
    @event_handler.rotors[1].position.must_equal 0
    @event_handler.rotors.first.position.must_equal 1
  end

  it "maps through all rotors" do
    rotor_three_map = @event_handler.rotors.last.mapping[0]
    rotor_two_map = @event_handler.rotors[1].mapping[rotor_three_map]
    expected_output = @event_handler.rotors.first.mapping[rotor_two_map]

    @event_handler.input(0).must_equal expected_output
  end

  it "outputs through all rotors" do
    val = @event_handler.input(0)
    @event_handler.rotors.map(&:reset)
    @event_handler.reflect(val).must_equal 0
  end
end
