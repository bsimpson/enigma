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
    @event_handler.input("a")
    @event_handler.rotors.last.position.must_equal 1
  end

  it "rolls over at 27" do
    @event_handler.rotors.last.position = 25 
    @event_handler.increment!
    @event_handler.rotors.last.position.must_equal 0
  end

  it "increments adjacent rotor" do
    @event_handler.rotors.last.position = 25 
    @event_handler.increment!
    @event_handler.rotors[1].position.must_equal 1
  end

  it "inputs through all rotors" do
    @event_handler.rotors.last.position = 25
    @event_handler.rotors[1].position = 25
    @event_handler.rotors.first.position = 0

    @event_handler.increment!

    @event_handler.rotors.last.position.must_equal 0
    @event_handler.rotors[1].position.must_equal 0
    @event_handler.rotors.first.position.must_equal 1
  end

  it "maps through all rotors" do
    rotor_three_map = @event_handler.rotors.last.mapping[0]
    rotor_two_map = @event_handler.rotors[1].mapping[rotor_three_map]
    rotor_one_map = @event_handler.rotors.first.mapping[rotor_two_map]
    expected_value = ("a".."z").to_a[rotor_one_map]

    @event_handler.input("a").must_equal expected_value
  end

  it "reflects through all rotors" do
    output = @event_handler.input("a")
    @event_handler.rotors.last.position = 0
    @event_handler.rotors[1].position = 0
    @event_handler.rotors.first.position = 0

    @event_handler.reflector(output).must_equal "a"
  end
end
