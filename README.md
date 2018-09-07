# Enigma

Germany's solution to encryption in World War II

![Enigma rotors](https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Enigma_rotors_with_alphabet_rings.jpg/220px-Enigma_rotors_with_alphabet_rings.jpg "Enigma Rotors")

Image credit [TedColes via Wikipedia](https://commons.wikimedia.org/wiki/User:TedColes)

# Background

I became interested in how the Engima machine works so I've started to replicate some of its key components after watching a few videos:

[![Flaw in the Enigma Code - Numberphile](http://img.youtube.com/vi/V4V2bpZlqx8/0.jpg)](http://www.youtube.com/watch?v=V4V2bpZlqx8)
[![Turing's Enigma Problem (Part 1) - Computerphile](http://img.youtube.com/vi/d2NWPG2gB_A/0.jpg)](http://www.youtube.com/watch?v=d2NWPG2gB_A)

These detail how the enigma machine had three rotors that were connected so that when each turned over it would increment the wheel to its left (similar to an odometer).

# Implementation

I have recreated the Wehrmacht Enigma machine used for commerce. The military version had a plug board which added to the number of combinations. (Not yet implemented)

The implementation here takes three rotors (in any order) and allows you to set the positions. The rotors you chose, and the positions of each rotor would be securely transmitted
to your recipient. Or you can use Alan Turing's Bombe machine to brute force! :)

## Background

To explain the Enigma (tersely) it helps to explain its predecessors. The earliest cipers started as monoalphabetic. These substituted a letter for another letter of the alphabet. For example:

```
CIPHER ABCDEFGHIJKLMNOPQRSTUVWXYZ
       ETBGAFRMKIUPYDQJCVXOWHZLSN

PLAINTEXT: DOG
ENCRYPTED: GQR
```

Next came the Ceasar cipher, named for Julius Ceasar. This took the monoalphabetic cipher and started from a letter other than A. For example:

```
CIPHER ABCDEFGHIJKLMNOPQRSTUVWXYZ
       BCDEFGHIJKLMNOPQRSTUVWXYZA

PLAINTEXT: DOG
ENCRYPTED: EPH
```

This would be a Ceasar B cipher. B since we start at offset B. There are 26 ways you shift the cipher for added complexity. (Of course a Ceasar A shift would be pretty useless so really 25)

Next came the Vigenère, which builds on the Ceasar cipher. It works by putting in a keyword above the letter. The keyword is repeated for each letter of the message. Each letter of the keyword
corresponds to the shift in a Ceasar cipher. For example the keyword "LEMON":

```
KEYWORD: 	LEMONLEMONLE
PLAINTEXT: 	ATTACKATDAWN
ENCRYPTED: 	LXFOPVEFRNHR
```

The "A" in the plaintext is encrypted using the Ceasar L cipher. The "E" is encrypted using the Ceasar E cipher, and so on.

## Engima Implementation
     
Now we can talk about Enigma. It is basically a Vigenère cipher with a 26^3 keyword. The specific keyword is constructed using typically 5 pick 3 rotors.
Each rotor has 26 positions. And each starting rotor position is independently set. The rotors would increment on each character input.
When the rotor on the far right would reach its starting position again (26 rotations) it increments the rotor to its left. When the middle most rotor reaches its starting position
it increments the far left rotor. This is how we get our 26^3 keyword.

An interesting note is that this will result in the same character input resulting two different character outputs. Note that below
the character "i" is an "f", "z", "m", and "a". That sure defeats frequency analysis attacks!

```
  PLAINTEXT: ichbineinberliner
  ENCRYPTED: fljtzgwmawsekamov
```

That gives us 26x26x26 = 17,576 possible rotor states for each of the 6 wheel orders (input and output as the rotor manufacturing was not always known by interceptors) giving 6x17,576 = 105,456 machine states.
No small task to brute force, but trivial compared to what the military Enigma machine added - the plug board:

## Enigma Plugboard

The plug board adds more combinations than was available on the commercial models. Now we have 10 plug pairs (order doesn't matter):

```
26! / (6! 10! 2^10) = 150,738,274,937,250 combinations
```

105,456 (machine states) * 150,738,274,937,250  (plug states) = 158,962,555,217,826,360,000 combinations (that is 158 billion billion)

The Germans believed it to be uncrackable and used this machine for their military communications.

## Examples

On to the code!

You can create an instance of Engima and set its rotors and positions:

### Setting Rotor and Position

```ruby
  enigma = Enigma.new
  enigma.set_rotors(Enigma::RotorMapping::IIC, Enigma::RotorMapping::IC, Enigma::RotorMapping::IIIC)
  enigma.set_positions(1, 5, 3)
```

Note that other rotors can be made available in the rotor mappings file. The Germans added many rotors over the course of the war.

### Encrypt a Message

Now you are ready to encrypt a message:

```ruby
  enigma.input("ichbineinberliner") #=> "fljtzgwmawsekamov"
```

### Decrypt a Message (Reflector)

Observe that you need to reset the rotor positions to have the same values as the encrypted message:

```ruby
 engima.set_positions(1, 5, 3)
 enigma.reflect("fljtzgwmawsekamov") #=> "ichbineinberliner"
```

# Testing

Ruby tests are written in Minitest and live in the `test/` directory. Tests can be run via

```
rake test
```

# Contribution

Contribute by opening a PR or an issue on Github. 

# More Information

1. [Vigenère cipher](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher)
1. [Military Use of the Enigma](https://www.codesandciphers.org.uk/enigma/enigma3.htm)

# License

MIT License

Copyright (c) 2018 Ben Simpson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

