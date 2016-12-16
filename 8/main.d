#!/usr/bin/rdmd -unittest

import std.stdio;
import std.algorithm;
import std.array;
import std.range;
import std.file;
import std.conv;






/////////////////////////////////////////////////////////////
//    x
//    0 -------------> 50
// y 0
//   |
//   |
//   |
//   v
//
//



struct Screen
{
  enum WIDTH = 50;
  enum HEIGHT = 6;


  // not sure if 1d or 2s is going to be easier.
  bool[WIDTH * HEIGHT] pixels = false;


  void rect(int width, int height)
  {
    for (int x = 0; x < width; ++x)
    {
      for (int y = 0; y < height; ++y)
      {
        pixels[ind(x,y)] = true;
      }
    }
  }

  void rotateRow(int row, int dist)
  {
    auto currentRow = pixels[(WIDTH * row)..(WIDTH * (row+1))];
    // rotate
    currentRow[dist..$].bringToFront(currentRow[0..dist]);

    // reassign
    writeRow(row, currentRow);
  }

  void rotateColumn(int col, int dist)
  {
    auto currentColumn = pixels[col..$].stride(WIDTH).array;
    // rotate
    currentColumn[dist..$].bringToFront(currentColumn[0..dist]);

    // reassign
    writeColumn(col, currentColumn);
  }

  string toString()
  {
    string ret = "|----+----|----+----|----+----|----+----|----+----\n";
    for (int y = 0; y < HEIGHT; ++y)
    {
      for (int x = 0; x < WIDTH; ++x)
      {
        if (pixels[ind(x,y)])
        {
          ret ~= "#";
        }
        else
        {
          ret ~= ".";
        }
      }
      ret ~= "\n";
    }
    ret ~= "\n";
    return ret;
  }

  int population()
  {
    int pop = 0;
    foreach (pixel; pixels)
    {
      if (pixel)
      {
        pop++;
      }
    }
    return pop;
  }

private:
  int ind(int x, int y)
  {
    return (y * WIDTH + x);
  }

  void writeRow(int row, bool[] contents)
  {
    for (int x = 0; x < WIDTH; ++x)
    {
      pixels[ind(x, row)] = contents[x];
    }
  }

  void writeColumn(int col, bool[] contents)
  {
    for (int y = 0; y < HEIGHT; ++y)
    {
      pixels[ind(col, y)] = contents[y];
    }
  }
}

void main()
{
  puzzle1();
  puzzle2();
}


void puzzle1()
{

  auto screen = Screen();

  auto instructions = readText("input").split('\n');
  foreach(instruction; instructions)
  {
    auto split = instruction.split(' ');
    // Rect
    if (split.length == 2)
    {
      auto args = split[1].split('x');
      screen.rect(args[0].to!int, args[1].to!int);
    }
    // Rotate
    else if (split.length == 5)
    {
      auto direction = split[1];
      auto target = split[2].split('=')[1].to!int;
      auto distance = split[4].to!int;

      if (direction == "row")
      {
        screen.rotateRow(target, distance);
      }
      else
      {
        screen.rotateColumn(target, distance);
      }
    }
    writeln(instruction);
    writeln(screen);
    //readln();
  }

  writeln(screen.population);



}

void puzzle2()
{
}
