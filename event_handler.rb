class EventHandler
  attr_accessor :rotors

  def rotors=(rotors)
    @rotors = rotors
    @one, @two, @three = *rotors
  end

  def increment!
    @three.position += 1

    if @three.position == 26
      @three.position = 0
      @two.position += 1
    end

    if @two.position == 26
      @three.position = 0
      @two.position = 0
      @one.position += 1
    end

    if @one.position == 26
      @one.position = 0
      @two.position = 0
      @three.position = 0
    end
  end

  def input(character)
    character_position = ("a".."z").to_a.index(character)

    val = @one.input(@two.input(@three.input(character_position)))
    increment!
    ("a".."z").to_a[val]
  end

  def reflector(character)
    character_position = ("a".."z").to_a.index(character)

    val = @three.reflect(@two.reflect(@one.reflect(character_position)))
    ("a".."z").to_a[val]
  end
end
