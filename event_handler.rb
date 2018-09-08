class EventHandler
  attr_reader :rotors

  def rotors=(rotors)
    @rotors = rotors
    @one, @two, @three = *rotors
  end

  def rollover!(rotor)
    case rotor
      when @one
        [@one, @two, @three].map(&:reset)
      when @two
        @one.increment
      when @three
        @two.increment
    end
  end

  def input(position)
    @one.input(@two.input(@three.input(position))).tap do |val|
      @three.increment
    end
  end

  def reflect(position)
    @three.reflect(@two.reflect(@one.reflect(position))).tap do |val|
      @three.increment
    end
  end
end
