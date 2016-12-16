#!/usr/bin/rdmd -unittest

import std.typecons;
import std.stdio;
import std.string;
import std.conv;


void main()
{
  puzzle1();
  puzzle2();
}

alias Nullable!int Hand;


struct Bot
{
  int index;

  int highDestination;
  bool highIsOutput;

  int lowDestination;
  bool lowIsOutput;
}

struct Factory
{
  Hand[] left = new Hand[300];
  Hand[] right = new Hand[300];
  Hand[] output = new Hand[30];

  Bot[] behaviors = new Bot[300];

  // Gives a chip of value chip to the specified bot.
  void give(int chip, int bot)
  {
    if (left[bot].isNull)
    {
      left[bot] = chip;
    }
    else if (right[bot].isNull)
    {
      right[bot] = chip;
    }
    else
    {
      assert(0, "attempted to give a third chip to a bot! Internal error! Bot: " ~ bot.to!string);
    }

    // If both hands are full, the bot will zoom off, giving it's chips appropriately.
    if (!left[bot].isNull && !right[bot].isNull)
    {
      auto behavior = behaviors[bot];

      int high;
      int low;
      if (left[bot] > right[bot])
      {
        high = left[bot];
        low = right[bot];
      }
      else
      {
        low = left[bot];
        high = right[bot];
      }

      // puzzle 1 check
      if (high == 61 && low == 17)
      {
        writeln("I'm bot: " ~ bot.to!string ~ ", and I'm comparing 61 and 17!!");
      }

      left[bot].nullify();
      right[bot].nullify();

      // If its output, just set it aside.
      if (behavior.highIsOutput)
      {
        output[behavior.highDestination] = high;
      }
      // Otherwise, give the chip.
      else
      {
        give(high, behavior.highDestination);
      }

      // same for low.
      if (behavior.lowIsOutput)
      {
        output[behavior.lowDestination] = low;
      }
      else
      {
        give(low, behavior.lowDestination);
      }
    }
  }
}

void puzzle1()
{
  // So the order of the instructions appears to be somewhat irrelevant.
  // The actual order of 'execution' by the bots is dictated by when they receive their chips.
  // I believe this means I can gather all of the 'goes to' instructions first, then simulate
  // the bots' behavior afterward. Order probably still matters between the "value" lines, though.
  // Instruction is actually probably the wrong word. It's more of a behavior description than anything.

  // going to model the state of the bots as two arrays. A bot has two chips if its index is occupied in both.
  // Going to try D's nullable. See how it does.

  auto factory = Factory();

  string[] valueInits;

  auto lines = File("input").byLine;
  foreach (line; lines)
  {
    auto split = line.split(' ');
    if (split.length == 12)
    {
      auto bot = Bot();
      bot.index = split[1].to!int;
      bot.lowDestination = split[6].to!int;
      bot.lowIsOutput =  split[5] == "output";
      bot.highDestination = split[11].to!int;
      bot.highIsOutput = split[10] == "output";
      factory.behaviors[bot.index] = bot;
    }
    else
    {
      valueInits ~= line.to!string;
    }
  }

  // Run through the value inits, giving the chips to the bots.

  foreach (value; valueInits)
  {
    auto split = value.split(' ');
    auto chip = split[1].to!int;
    auto bot = split[5].to!int;
    factory.give(chip, bot);
  }

  // puzzle2 check
  writeln(factory.output[0] * factory.output[1] * factory.output[2]);
}

void puzzle2()
{
}
