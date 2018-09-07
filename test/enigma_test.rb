require "minitest/autorun"
require "./enigma"

describe Enigma do
  before do
    @enigma = Enigma.new 
  end

  it "sets rotors" do
    @enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
    @enigma.event_handler.rotors[0].mapping.must_equal Enigma::RotorMapping::IIC
    @enigma.event_handler.rotors[1].mapping.must_equal Enigma::RotorMapping::IC
    @enigma.event_handler.rotors[2].mapping.must_equal Enigma::RotorMapping::IIIC
  end

  it "sets rotor positions" do
    @enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
    @enigma.set_positions(1, 5, 3)
    @enigma.event_handler.rotors[0].position.must_equal 1
    @enigma.event_handler.rotors[1].position.must_equal 5
    @enigma.event_handler.rotors[2].position.must_equal 3
  end

  it "encrypts" do
    @enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
    @enigma.set_positions(1, 5, 12)
    @enigma.input("ichbineinberliner").must_equal "fljtzgwmawsekamov"
  end

  it "decrypts" do
    @enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
    @enigma.set_positions(1, 5, 12)
    @enigma.reflect("fljtzgwmawsekamov").must_equal "ichbineinberliner"
  end

  it "enrypts with rollover" do
    @enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
    @enigma.set_positions(1, 5, 22)
    plaintext = "thisisatestoftheemergencybroadcastsystem"
    encrypted_value = @enigma.input(plaintext)

    @enigma.set_positions(1, 5, 22)
    @enigma.reflect(encrypted_value).must_equal(plaintext)
  end

  it "converts char to code" do
    @enigma.char_code("a").must_equal 0 
    @enigma.char_code("z").must_equal 25
  end

  it "converts code to char" do
    @enigma.code_char(0).must_equal "a"
    @enigma.code_char(25).must_equal "z"
  end
end
