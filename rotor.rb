require "./event_handler"

class Rotor
  attr_accessor :position, :event_handler, :mapping

  def initialize(event_handler:, position: 0)
    @position = position
    @event_handler = event_handler
  end

  def input(index)
    mapping[index]
  end

  def reflect(value)
    mapping.index(value)
  end

  def to_s
    { position: position }
  end

  def increment
    @mapping.push(@mapping.shift)
    @position += 1
    if (@position > 25)
      event_handler.rollover!(self)
      reset
    end
  end

  def reset
    @position.times do
      @mapping.unshift(@mapping.pop)
    end
    @position = 0
  end

  def position=(position)
    position.times { increment }
  end
end
