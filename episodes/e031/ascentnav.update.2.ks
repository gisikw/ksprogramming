// Genetic Algorithm Iterator
// Kevin Gisi
// http://youtube.com/gisikw

switch to 0.
run float.
run genetics.

clearscreen.
set terminal:width to 80.
set terminal:height to 5.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

function score_launch {
  local fuel is 0.
  for resource in ship:resources {
    if resource:name = "LiquidFuel" set fuel to resource.
  }

  // Penalty score
  local alt_score is min(ship:apoapsis / 100000, 1).

  // Real scores
  local ap_score is gaussian(ship:apoapsis, 100000, 50000).
  local ec_score is gaussian(obt:eccentricity, 0, 0.5).
  local fl_score is gaussian(fuel:amount / fuel:capacity, 1, 2).

  local total is 0.
  set total to total + ap_score * 10.
  set total to total + ec_score * 5.
  set total to total + fl_score.

  // Scale total based on penalty
  set total to total / max(1 - alt_score, 0.001).

  return total.
}

function gaussian {
  parameter value, target, width.
  return constant:e^(-1 * (value-target)^2 / (2*width^2)).
}

function run_launch {
  parameter chromosome.

  // Get values from chromosome
  local t_mul is 1/max(to_float(chromosome:substring(0,32)),0.0001).
  local t_exp is 1/max(to_float(chromosome:substring(32,32)),0.0001).
  local t_off is 1/max(to_float(chromosome:substring(64,32)),0.0001).
  local p_mul is to_float(chromosome:substring(96,32)).
  local p_exp is 1/max(to_float(chromosome:substring(128,32)),0.0001).
  local p_off is to_float(chromosome:substring(160,32)).
  local cut   is to_float(chromosome:substring(192,32)).

  // Throw some info at the user
  print "Generation " + ga_gen.
  print "Max TWR: " + t_mul+" x ^"+t_exp+" + "+t_off.
  print "Pitch: " + p_mul+" x ^"+p_exp+" + "+p_off.
  print "Cutoff: " + cut.

  // Initial launch
  lock throttle to 1.
  lock steering to heading(90, 90).
  stage. wait 5.

  // Get percentage of altitude
  lock pct_alt to (alt:radar / 100000).

  // Handle throttle control
  lock g to body:mu / ((ship:altitude + body:radius)^2).
  lock avail_twr to ship:maxthrust / (g * ship:mass).
  lock max_twr to t_mul * pct_alt^t_exp + t_off.

  lock throttle to max(min(max_twr / avail_twr,1),0).

  // Handle pitch control
  lock pitch to p_mul * pct_alt^p_exp + p_off.
  lock steering to heading(90, pitch).

  // Ensure we can get telemetry throughout the flight
  when alt:radar > 70000 then lights on.

  // Wait to terminate the test
  local part_count is ship:parts:length.
  until 0 {
    if ship:apoapsis > cut lock throttle to 0.

    if ship:apoapsis > cut and alt:radar > 70000 break.
    if alt:radar < 70000 and verticalspeed < -1 break.
    if ship:liquidfuel < 0.1 break.
    if alt:radar > 70000 and eta:apoapsis < 0.5 break.
    if ship:apoapsis > 99999 and ship:periapsis > 99999 break.
    if not addons:rt:hasconnection(ship) break.
    if part_count <> ship:parts:length break.
    if ship:electriccharge < 0.5 break.
    wait 0.1.
  }
  lock throttle to 0.

  // Log scores and revert
  local score is score_launch().
  hudtext(score, 5, 2, 50, yellow, false).
  if not addons:rt:hasconnection(ship) { lights on. wait until addons:rt:hasconnection(ship). }
  log "set last_fitness to " + score + "." to last_fitness.ks.
  kuniverse:reverttolaunch().
}

// Genetic algorithm stuff
function ga_fitness {
  parameter chromosome.

  // If the score is already cached, use that
  list files in fs.
  for f in fs {
    if f:name = "last_fitness.ks" {
      run last_fitness.ks. delete last_fitness.ks.
      return last_fitness.
    }
  }

  // Otherwise, run the test
  run_launch(chromosome).
}

until 0 ga_next().
