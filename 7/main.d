#!/usr/bin/rdmd -unittest


import std.ascii: lowercase;
import std.stdio;
import std.conv;
import std.regex;
import std.array;
import std.algorithm;


void main()
{
  puzzle1();
  puzzle2();
}


string[] generateAllABBAs()
{
  string[] abbas = [];
  // cross product
  foreach (char a; lowercase)
  {
    foreach (char b; lowercase)
    {
      // a and b must be different.
      if (a == b)
      {
        continue;
      }
      // Kinda silly. Looks like D is treating a and b as ints without appending them to a string?
      abbas ~= "" ~ a ~ b ~ b ~ a;
      abbas ~= "" ~ b ~ a ~ a ~ b;
    }
  }
  return abbas;
}

string [] generateAllABAs()
{
  string[] abbas = [];
  // cross product
  foreach (char a; lowercase)
  {
    foreach (char b; lowercase)
    {
      // a and b must be different.
      if (a == b)
      {
        continue;
      }
      // Kinda silly. Looks like D is treating a and b as ints without appending them to a string?
      abbas ~= "" ~ a ~ b ~ a;
      abbas ~= "" ~ b ~ a ~ b;
    }
  }
  return abbas;
}

// only done once :D
enum ABBAs = generateAllABBAs();
enum ABAs = generateAllABAs();

bool containsAbba(string input)
{
  foreach(abba; ABBAs)
  {
    if (input.canFind(abba))
    {
      return true;
    }
  }
  return false;
}

bool supportsTLS(string ip)
{
  enum insidePattern = ctRegex!(`\[.+?\]`);
  auto outside = ip.replaceAll(insidePattern, " ");
  auto inside = ip.matchAll(insidePattern).array.map!(capture => capture.hit).reduce!((a, b) => a ~ " " ~ b).replaceAll(ctRegex!"\\[", "").replaceAll(ctRegex!"\\]", "");
  return (outside.containsAbba() && !inside.containsAbba());
}

unittest
{
  assert("abba[mnop]qrst".supportsTLS);
  assert(!"abcd[bddb]xyyx".supportsTLS);
  assert(!"aaaa[qwer]tyui".supportsTLS);
  assert("ioxxoj[asdfgh]zxcvbn".supportsTLS);
  assert(!"abba[xxyy]abba[abba]axxa".supportsTLS);
  assert(!"abab[asdf]baba".supportsTLS);
}

bool supportsSSL(string ip)
{
  enum insidePattern = ctRegex!(`\[.+?\]`);
  auto outside = ip.replaceAll(insidePattern, " ");
  auto inside = ip.matchAll(insidePattern).array.map!(capture => capture.hit).reduce!((a, b) => a ~ " " ~ b).replaceAll(ctRegex!"\\[", "").replaceAll(ctRegex!"\\]", "");

  foreach(aba; ABAs)
  {
    auto bab = "" ~ aba[1] ~ aba[0] ~ aba[1];
    if (outside.canFind(aba) && inside.canFind(bab))
    {
      return true;
    }
  }
  return false;
}

unittest
{
  assert("aba[bab]bob".supportsSSL);
  assert(!"xyx[xyx]xyx".supportsSSL);
  assert("aaa[kek]eke".supportsSSL);
  assert("zazbz[bzb]cdb".supportsSSL);
}



void puzzle1()
{
  auto IPs = File("input").byLine.map!(ip => ip.to!string).array;
  auto count = 0;
  foreach(ip; IPs)
  {
    if (ip.supportsTLS)
    {
      count++;
    }
  }
  writeln(count);
}

void puzzle2()
{
  auto IPs = File("input").byLine.map!(ip => ip.to!string).array;
  auto count = 0;
  foreach(ip; IPs)
  {
    if (ip.supportsSSL)
    {
      count++;
    }
  }
  writeln(count);
}
