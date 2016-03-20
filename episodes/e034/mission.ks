// +---------------------+ //
// | Version 4: Missions | //
// +---------------------+ //
run mission_runner.ks.

set main_sequence to list(
  "Launch", launch@,
  "Gravity Turn", gravity_turn@,
  "Main-Engine Cutoff", main_engine_cutoff@
).

set events to lex(
  "Power Check", ensure_power@
).

run_mission(main_sequence, events).

function launch {
  parameter mission.

  print "Launching!".
  lock steering to heading(90, 90).
  lock throttle to 1.
  stage.
  mission["next"]().
}

function gravity_turn {
  parameter mission.

  if altitude > 30000 {
    lock steering to heading(90, 65).
    mission["next"]().
  }
}

function main_engine_cutoff {
  parameter mission.

  if altitude > 70000 {
    panels on.
    lock throttle to 0.
    mission["next"]().
  }
}

function ensure_power {
  parameter mission.
  if ship:electriccharge < 10 disable_antennas().
}
