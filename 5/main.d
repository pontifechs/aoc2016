#!/usr/bin/rdmd -unittest

import std.stdio;
import std.conv;
import std.digest.md;
import std.parallelism;
import std.range;

void main()
{
  // puzzle1();
  puzzle2();
}

void puzzle1()
{
  // lets try brute force.
  auto matches = 0;
  auto input = "wtnhxymk";

  for (int i = 0; matches < 8; ++i)
  {
    auto md5 = new MD5Digest();
    auto hash = md5.digest(input ~ i.to!string).toHexString;
    if (hash[0..5] == "00000")
    {
      writeln(hash);
      matches++;
    }
  }
}

void puzzle2()
{

  auto input = "wtnhxymk";
  auto indices = iota(50_000_000);

  char[] pass = ['_','_','_','_','_','_','_','_'];

  foreach (i; indices)
  {
    auto md5 = new MD5Digest();
    auto hash = md5.digest(input ~ i.to!string).toHexString;
    if (hash[0..5] == "00000")
    {
      if (pass[0] == '_' && hash[5] == '0')
      {
        pass[0] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[1] == '_' && hash[5] == '1')
      {
        pass[1] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[2] == '_' && hash[5] == '2')
      {
        pass[2] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[3] == '_' && hash[5] == '3')
      {
        pass[3] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[4] == '_' && hash[5] == '4')
      {
        pass[4] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[5] == '_' && hash[5] == '5')
      {
        pass[5] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[6] == '_' && hash[5] == '6')
      {
        pass[6] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
      if (pass[7] == '_' && hash[5] == '7')
      {
        pass[7] = hash[6];
        writeln(pass.to!string, " ", hash, " ", i);
      }
    }
  }
}
