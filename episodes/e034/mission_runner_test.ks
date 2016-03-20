run mission_runner.ks.

set sequence to list(
  "wakeup", wakeup@,
  "smell the roses", smell_roses@,
  "be awesome", be_awesome@
).

set events to lex(
  "interrupt", interrupt@,
  "die eventually", die_eventually@
).

set now to time:seconds.
run_mission(sequence, events).

function interrupt {
  parameter mission.
  print "I'm interrupting".
  wait 0.5.
}

function wakeup {
  parameter mission.
  print "Waking up".
  function extra_event {
    parameter mission.
    print "Extra event happening during runmode " + mission["runmode"]().
  }
  mission["add_event"]("Extra event", extra_event@).
  mission["next"]().
}

function smell_roses {
  parameter mission.
  print "Smelling roses".
  mission["next"]().
}

function be_awesome {
  parameter mission.
  print "Being awesome".
  mission["remove_event"]("Extra event").
  mission["switch_to"]("smell the roses").
}

function die_eventually {
  parameter mission.
  if time:seconds > now + 5 {
    print "Five seconds have passed. Terminating".
    mission["terminate"]().
  }
}
