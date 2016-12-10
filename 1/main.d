#!/usr/bin/env rdmd 

import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.math;
import std.algorithm;

void main(string[] args)
{
  puzzle1();
  puzzle2();
}

enum Cardinal
{
  North, East, West, South
};

enum Direction
{
  Left = 'L', Right = 'R'
};


Cardinal turn(Cardinal facing, Direction turn)
{
  if (turn == Direction.Left)
  {
    final switch (facing)
    {
      case Cardinal.North:
        return Cardinal.West;
      case Cardinal.West:
        return Cardinal.South;
      case Cardinal.South:
        return Cardinal.East;
      case Cardinal.East:
        return Cardinal.North;
    }
  }
  else
  {
    final switch (facing)
    {
      case Cardinal.North:
        return Cardinal.East;
      case Cardinal.East:
        return Cardinal.South;
      case Cardinal.South:
        return Cardinal.West;
      case Cardinal.West:
        return Cardinal.North;
    }
  }
}

void puzzle1()
{
  auto instructions = readText("input").split(", ");

  auto x = 0;
  auto y = 0;
  auto facing = Cardinal.North;

  foreach (instruction; instructions)
  {
    auto direction = instruction[0].to!Direction;
    auto distance = instruction[1..$].to!int;
    // Turn.
    facing = facing.turn(direction);

    // Then travel.
    final switch (facing)
    {
      case Cardinal.North:
        y += distance;
        break;
      case Cardinal.East:
        x += distance;
        break;
      case Cardinal.South:
        y -= distance;
        break;
      case Cardinal.West:
        x -= distance;
        break;
    }
  }

  auto blocksAway = x.abs + y.abs;
  writeln("End is: ", blocksAway);
}


struct Point
{
  int x = 0;
  int y = 0;
}

int distance(Point p)
{
  return p.x.abs + p.y.abs;
}

void puzzle2()
{
  auto instructions = readText("input").split(", ");
  Point[] points = [];

  auto point = Point();
  auto facing = Cardinal.North;

  foreach (instruction; instructions)
  {

    auto direction = instruction[0].to!Direction;
    auto distance = instruction[1..$].to!int;
    // Turn.
    facing = facing.turn(direction);

    // Then travel, noting each coordinate passing through.
    for (int i = 0; i < distance; ++i)
    {
      // Write down where we are.
      points ~= point;

      final switch (facing)
      {
        case Cardinal.North:
          point.y++;
          break;
        case Cardinal.East:
          point.x++;
          break;
        case Cardinal.South:
          point.y--;
          break;
        case Cardinal.West:
          point.x--;
         break;
      }

      // Check if we've been here before.
      if (points.canFind(point))
      {
        writeln("End is: ", point, " for distance: ", point.distance);
        return;
      }
    }
  }
}

