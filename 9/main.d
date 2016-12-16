#!/usr/bin/rdmd -unittest

import std.file;
import std.stdio;
import std.string;
import std.conv;

void main()
{
  puzzle1();
  puzzle2();
}


void puzzle1()
{

  auto file = readText("input");

  // going to advance through the file character by character, and keep some state about what we're doing along the way

  // puzzle 1 doesn't actually require me to generate the decompressed file.
  // but I assume puzzle 2 is going to require it, so I'll just do it.
  auto decompressed = "";

  // This is the character that we're currently examining.
  auto pointer = 0;
  while (pointer < file.length)
  {
    if (file[pointer] == '(')
    {
      auto startMarker = pointer + 1;
      // Find the next closing brace.
      while (file[pointer] != ')' && pointer < file.length)
      {
        pointer++;
      }
      auto marker = file[startMarker..pointer];
      auto split = marker.split('x');
      auto length = split[0].to!int;
      auto times = split[1].to!int;

      // Advance off of the closing paren.
      pointer++;
      // Decompress

      auto duplicated = file[pointer..pointer+length];
      foreach (i; 0..times)
      {
        decompressed ~= duplicated;
      }

      pointer += length;
    }
    else
    {
      decompressed ~= file[pointer];
      pointer++;
    }
  }

  writeln(decompressed.length);
}



long decompressedLength(string file)
{
  // This is the character that we're currently examining.
  auto pointer = 0;

  long fileLength = 0;

  while (pointer < file.length)
  {
    if (file[pointer] == '(')
    {
      auto startMarker = pointer + 1;
      // Find the next closing brace.
      while (file[pointer] != ')' && pointer < file.length)
      {
        pointer++;
      }
      auto marker = file[startMarker..pointer];
      auto split = marker.split('x');
      auto length = split[0].to!int;
      auto times = split[1].to!int;

      // Advance off of the closing paren.
      pointer++;

      auto duplicated = file[pointer..pointer+length];
      fileLength += decompressedLength(duplicated) * times;

      pointer += length;
    }
    else
    {
      fileLength++;
      pointer++;
    }
  }
  return fileLength;
}

unittest
{
  assert("(3x3)XYZ".decompressedLength == 9);
  assert("X(8x2)(3x3)ABCY".decompressedLength == 20);
  assert("(27x12)(20x12)(13x14)(7x10)(1x12)A".decompressedLength == 241_920);
  assert("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN".decompressedLength == 445);
}


void puzzle2()
{

  // Ahh. turns out they went the other way and decided to punish you for actually trying to get the full decompressed output.
  // oh well. it's pretty easy to just do math.
  auto file = readText("input");
  writeln(file.decompressedLength);


}
