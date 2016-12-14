#!/usr/bin/rdmd -unittest

import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;
import std.file;


void main()
{
  puzzle1();
  puzzle2();
}


bool validTriangle(int a, int b, int c)
{
  return (a + b > c) && (b + c > a) && (a + c > b);
}

void puzzle1()
{
  auto lines = File("input").byLine;

  auto count = 0;
  foreach(line; lines)
  {
    auto triple = line.split.map!(a => a.to!int);
    if (validTriangle(triple[0], triple[1], triple[2]))
    {
      count++;
    }
  }
  writeln(count);
}

void puzzle2()
{
  auto numbers = readText("input").split.map!(a => a.to!int);

  auto count = 0;
  for (int i = 0; i < numbers.length; i += 9)
  {
    if (validTriangle(numbers[i]  , numbers[i+3], numbers[i+6]))
    {
      count++;
    }
    if (validTriangle(numbers[i+1], numbers[i+4], numbers[i+7]))
    {
      count++;
    }
    if (validTriangle(numbers[i+2], numbers[i+5], numbers[i+8]))
    {
      count++;
    }
  }
  writeln(count);
}
