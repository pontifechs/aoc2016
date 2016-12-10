#!/usr/bin/rdmd -unittest


import std.stdio;
import std.file;
import std.conv;

enum Direction
{
  Right = 'R',
  Left = 'L',
  Up = 'U',
  Down = 'D'
}


// 1 2 3
// 4 5 6
// 7 8 9
int move(int current, Direction d)
{
  assert(current > 0 && current < 10);
  final switch(d)
  {
    case Direction.Up:
      if (current < 4)
      {
        return current;
      }
      else
      {
        return current - 3;
      }
      break;
    case Direction.Right:
      if (current % 3 == 0)
      {
        return current;
      }
      else
      {
        return current + 1;
      }
      break;
    case Direction.Down:
      if (current > 6)
      {
        return current;
      }
      else
      {
        return current + 3;
      }
      break;
    case Direction.Left:
      if ((current - 1) % 3 == 0)
      {
        return current;
      }
      else
      {
        return current - 1;
      }
      break;
  }
}

// Edges
unittest
{
  assert(1.move(Direction.Left) == 1);
  assert(4.move(Direction.Left) == 4);
  assert(7.move(Direction.Left) == 7);

  assert(1.move(Direction.Up) == 1);
  assert(2.move(Direction.Up) == 2);
  assert(3.move(Direction.Up) == 3);

  assert(3.move(Direction.Right) == 3);
  assert(6.move(Direction.Right) == 6);
  assert(9.move(Direction.Right) == 9);

  assert(7.move(Direction.Down) == 7);
  assert(8.move(Direction.Down) == 8);
  assert(9.move(Direction.Down) == 9);
}

unittest
{
  assert(5.move(Direction.Up) == 2);
  assert(5.move(Direction.Right) == 6);
  assert(5.move(Direction.Down) == 8);
  assert(5.move(Direction.Left) == 4);
}

void main()
{
  puzzle1();
  puzzle2();
}

void puzzle1()
{
  auto digitInstructions = File("input").byLine;
  writeln("keypad 1: ");
  foreach (digitInstruction; digitInstructions)
  {
    auto current = 5;
    foreach (char c; digitInstruction)
    {
      auto direction = c.to!Direction;
      current = current.move(direction);
    }
    write(current);
  }
  writeln();
}

// Instead of mapping these directly, i'll spoof it by using a larger keypad:
// 1  2  3  4  5
// 6  7  8  9  10
// 11 12 13 14 15
// 16 17 18 19 20
// 21 22 23 24 25
//
// Simplifying the movement rules by blacklisting the non-keys (1, 2, 4, 5, 6, 10, ....)
// Luckily, it looks like none of the wrappings (15.naiveMoveRight == 16 e.g.)are actually valid keys, so this turns out to be easy.
// 
// Then mapping the number here to its proper Key.




enum keyMap = [
  3 : '1',
  7 : '2',
  8 : '3',
  9 : '4',
  11 : '5',
  12 : '6',
  13 : '7',
  14 : '8',
  15 : '9',
  17 : 'A',
  18 : 'B',
  19 : 'C',
  23 : 'D'
  ];

int move2(int current, Direction d)
{
  // ensure we're moving from a valid position.
  assert(current in keyMap);

  auto destination = 0;
  // Blindly move.
  final switch(d)
  {
    case Direction.Up:
      destination = current - 5;
      break;
    case Direction.Right:
      destination = current + 1;
      break;
    case Direction.Down:
      destination = current + 5;
      break;
    case Direction.Left:
      destination = current - 1;
      break;
  }

  // If the move would be invalid it's a no-op.
  if (destination in keyMap)
  {
    return destination;
  }
  else
  {
    return current;
  }
}



void puzzle2()
{
  auto digitInstructions = File("input").byLine;
  writeln("keypad 2: ");
  foreach (digitInstruction; digitInstructions)
  {
    auto current = 13;
    foreach (char c; digitInstruction)
    {
      auto direction = c.to!Direction;
      current = current.move2(direction);
    }
    write(keyMap[current]);
  }
  writeln();

}




