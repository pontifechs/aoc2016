#!/usr/bin/rdmd -unittest

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;
import std.ascii;

void main()
{
  puzzle1();
  puzzle2();
}

void puzzle1()
{
  auto lines = File("input").byLine;

  // Going to gather up all the characters for each position in the message
  string[] histograms = [];

  foreach(c; lines.front)
  {
    histograms ~= "";
  }

  foreach(line; lines)
  {
    foreach(int i, char c; line)
    {
      histograms[i] ~= c;
    }
  }

  foreach(histogram; histograms)
  {
    auto byMostPopular = lowercase.array.sort!((a, b) => histogram.count(a) > histogram.count(b));
    write(byMostPopular[0]);
  }
  writeln();
}

void puzzle2()
{

  // puzzle two is identical, except we sort the other direction at the end.

  auto lines = File("input").byLine;

  string[] histograms = [];

  foreach(c; lines.front)
  {
    histograms ~= "";
  }

  foreach(line; lines)
  {
    foreach(int i, char c; line)
    {
      histograms[i] ~= c;
    }
  }

  foreach(histogram; histograms)
  {
    auto byMostPopular = lowercase.array.sort!((a, b) => histogram.count(a) < histogram.count(b));
    write(byMostPopular[0]);
  }
  writeln();

}
