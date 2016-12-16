#!/usr/bin/rdmd -unittest


void main()
{
  puzzle1();
  puzzle2();
}

// Rules::
// 1. X Chip + Y Generator (without X's gen) == X Fried
// 2. X Chip + X Generator + Y Generator == Safe
// 3. X Chip + X Generator + Y Chip == Y Fried
// 4. Must have at least one thing to change floors (Fuck this rule, hahahah)
// 5. Elevator can only carry two items
// 6. Elevator must stop on each floor
// 7. X Chip + Y Chip == Safe
// 8. X Gen + Y Gen == Safe
//

// My input:
// The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, and a strontium generator.
// The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
// The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
// The fourth floor contains nothing relevant.


// T == Thulium
// P == Plutonium
// S == Strontium
// O == Promethium
// R == Ruthenium

// F4 .  .  .  .  .  .
// F3 .  OG OM RG RM .
// F2 .  PM SM .  .  .
// F1 E  TG TM PG SG .

// Notes -------------------------------------------------------
// I can establish a lower bound on the number of moves, I think.
// Each item will need to travel at least the distance from where it is to the top floor.
// And the elevator can only carry two at a time. So assuming nothing ever gets fried, we need at least
// 20 moves, since at most, an move can gain only 1 floor of height per item.
//


import std.traits;
import std.stdio;
import std.algorithm;

enum Element
{
  Thulium,
  Plutonium,
  Strontium,
  Promethium,
  Ruthenium
}

// For checking cross contamination, we don't need Thulium/Thulium e.g. Since if both are present, we're fine.
enum elementCombos = cartesianProduct([EnumMembers!Element], [EnumMembers!Element]).filter!(combo => combo[0] != combo[1]);

struct Floor
{
  bool[Element] chips;
  bool[Element] generators;

  bool chipsSafe()
  {
    foreach (combo; elementCombos)
    {
      auto chipElement = combo[0];
      auto genElement = combo[1];

      if ((chipElement in chips) && (genElement in generators))
      {
        return false;
      }
    }
    return true;
  }

  Element[] chipsPresent()
  {
    return chips.keys;
  }

  Element[] generatorsPresent()
  {
    return generators.keys;
  }
}

unittest
{
  Floor f = Floor();
  f.chips[Element.Thulium] = true;
  f.generators[Element.Thulium] = true;

  assert(f.chipsSafe());
}

unittest
{
  Floor f = Floor();
  f.chips[Element.Thulium] = true;
  f.generators[Element.Plutonium] = true;

  assert(!f.chipsSafe());
}

unittest
{
  Floor f = Floor();
  f.chips[Element.Thulium] = true;
  f.chips[Element.Plutonium] = true;

  assert(f.chipsSafe());
}

unittest
{
  Floor f = Floor();
  f.generators[Element.Thulium] = true;
  f.generators[Element.Plutonium] = true;

  assert(f.chipsSafe());
}

struct Facility
{
  Floor[4] floors;
  int elevatorFloor = 0;
}

void puzzle1()
{
  auto EBHQ = Facility();
  EBHQ.floors[0].generators[Element.Thulium] = true;
  EBHQ.floors[0].chips[Element.Thulium] = true;
  EBHQ.floors[0].generators[Element.Plutonium] = true;
  EBHQ.floors[0].generators[Element.Strontium] = true;

  writeln(EBHQ);
}

void puzzle2()
{
}
