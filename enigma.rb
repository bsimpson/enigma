require_relative './rotor'

class Enigma
  def initialize
    @event_handler = EventHandler.new
    rotor_one = Rotor.new(event_hander: event_handler)
    rotor_two = Rotor.new(event_hander: event_handler)
    rotor_three = Rotor.new(event_hander: event_handler)

    @event_handler.rotors = [rotor_one, rotor_two, rotor_three]
  end

  def set_positions(one, two, three)
  end

  def input(character)
    @event_handler.input(character)
  end

  def reflect(character)
    @event_handler.reflect(character)
  end
end
