run_mission(
  list( // sequence
    "launch", { parameter mission.
      //mission["next"]().
    }
    "tilt", {},
    "whatever", {},
    "circularize", {}
  ),

  lex( // events
    "booster", {
      parameter mission.
      if stage:solidfuel < 0.5 {
        brakes on.
        mission["remove_event"]("booster").
      }
    }
  )
).


