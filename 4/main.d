#!/usr/bin/rdmd -unittest

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.string;
import std.ascii;

void main()
{
  puzzle1();
  puzzle2();
}


struct Room
{
  string roomCode;
  string givenCheckSum;
  int sector;

  static opCall(string fullCode)
  {
    auto split = fullCode.split("-");
    Room room;
    room.roomCode = split[0..$-1].join("-");

    // luckily, sector codes are always three digits in my dataset.
    room.sector = split[$-1][0..3].to!int;
    room.givenCheckSum = split[$-1][4..$-1];
    return room;
  }

  bool valid()
  {
    return givenCheckSum == generateCheckSum();
  }

  string generateCheckSum()
  {
    auto deduped = roomCode.filter!(a => a != '-').array.sort().uniq;
    return deduped.array.sort!((a, b) => roomCode.count(a) > roomCode.count(b), SwapStrategy.stable).to!string[0..5];
  }
}

Room[] readRooms()
{
  auto lines = File("input").byLine;
  return lines.map!(line => Room(line.to!string)).array;
}

// Given rooms
unittest
{
  auto room = Room("aaaaa-bbb-z-y-x-123[abxyz]");
  assert(room.valid);
}

unittest
{
  auto room = Room("a-b-c-d-e-f-g-h-987[abcde]");
  assert(room.valid);
}

unittest
{
  auto room = Room("not-a-real-room-404[oarel]");
  assert(room.valid);
}

unittest
{
  auto room = Room("totally-real-room-200[decoy]");
  assert(!room.valid);
}

void puzzle1()
{
  auto rooms = readRooms();
  auto sum = 0;
  foreach (room; rooms)
  {
    if (room.valid)
    {
      sum += room.sector;
    }
  }
  writeln(sum);
}



// This was helpful: https://rosettacode.org/wiki/Rot-13#D
auto buildRotN(int n)
{
  auto trueN = n % 26;
  if (trueN == 0)
  {
    return makeTrans(lowercase, lowercase);
  }

  return makeTrans(lowercase, lowercase[trueN .. uppercase.length] ~ lowercase[0..trueN]);
}


unittest
{
  auto input = "qzmt-zixmtkozy-ivhz";
  assert(input.translate(buildRotN(343)) == "very-encrypted-name");
}


void puzzle2()
{
  auto rooms = readRooms();
  foreach(room; rooms)
  {
    writeln(room.roomCode.translate(buildRotN(room.sector)), " ", room.sector);
  }
}
