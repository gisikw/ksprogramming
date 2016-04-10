// Mission Runner v0.1.0
// Kevin Gisi
// http://youtube.com/gisikw

{
  function mission_runner {
    parameter sequence, events is lex().
    local runmode is 0. local done is 0.

    // This object gets passed to sequences and events, to allow them to
    // interact with the event loop.
    local mission is lex(
      "add_event", add_event@,
      "remove_event", remove_event@,
      "next", next@,
      "switch_to", switch_to@,
      "runmode", report_runmode@,
      "terminate", terminate@
    ).

    // Recover runmode from disk
    if core:volume:exists("mission.runmode") {
      local last_mode is core:volume:open("mission.runmode"):readall():string.
      local n is indexof(sequence, last_mode).
      if n <> -1 update_runmode(n / 2).
    }

    // Main event loop
    until done {
      sequence[runmode * 2 + 1](mission).
      for event in events:values event(mission).
      wait 0.01.
    }
    if core:volume:exists("mission.runmode")
      core:volume:delete("mission.runmode").

    // Update runmode, persisting to disk
    function update_runmode {
      parameter n.
      if not core:volume:exists("mission.runmode")
        core:volume:create("mission.runmode").
      local file is core:volume:open("mission.runmode").
      file:clear().
      file:write(sequence[2 * n]).
      set runmode to n.
    }

    // List helper function
    function indexof {
      parameter _list, item. local i is 0.
      for el in _list {
        if el = item return i.
        set i to i + 1.
      }
      return -1.
    }

 // +---------------------------------------------------+
 // | Mission functions, passed to sequences and events |
 // +---------------------------------------------------+

    // Add a new named event to the main event loop
    function add_event {
      parameter name, delegate.
      set events[name] to delegate.
    }

    // Remove an event by name
    function remove_event {
      parameter name.
      events:remove(name).
    }

    // Switch to the next available runmode
    function next {
      update_runmode(runmode + 1).
    }

    // Switch to a specific runmode by name
    function switch_to {
      parameter name.
      update_runmode(indexof(sequence, name) / 2).
    }

    // Return the current runmode (read-only)
    function report_runmode {
      return sequence[runmode * 2].
    }

    // Allow explicit termination of the event loop
    function terminate {
      set done to 1.
    }
  }

  global run_mission is mission_runner@.
}
