require "./event_handler"

class Rotor
  attr_accessor :position, :event_handler

  def initialize(event_handler:, position: 0)
    self.position = position
    self.event_handler = event_handler
  end

  def input(character)
    mapping[character]
  end

  def reflect(character)
    mapping.key(character)
  end

  def to_s
    { position: position }
  end

  def mapping
    @mapping ||= begin
      remaining = (0..25).to_a
      pairs = {}

      while remaining.length > 0
        input, output = remaining.sample(2)
        pairs[input] = output
        pairs[output] = input

        remaining.delete(input)
        remaining.delete(output)
      end

      pairs
    end
  end
end
