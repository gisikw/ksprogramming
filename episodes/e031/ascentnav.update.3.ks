// Genetic Algorithm Profiler
// Kevin Gisi
// http://youtube.com/gisikw

switch to 0.
run float.
local start_time is time:seconds.

local chromosome is "00111111100111001011000011000100010000000111010101111111001111100011111110001010101101110100000011000010111001100111101010001000010000000011000001001000101001100100001010110000011011011110111001010111110100001010010111001010".

// Get values from chromosome
local t_mul is 1/max(to_float(chromosome:substring(0,32)),0.0001).
local t_exp is 1/max(to_float(chromosome:substring(32,32)),0.0001).
local t_off is 1/max(to_float(chromosome:substring(64,32)),0.0001).
local p_mul is to_float(chromosome:substring(96,32)).
local p_exp is 1/max(to_float(chromosome:substring(128,32)),0.0001).
local p_off is to_float(chromosome:substring(160,32)).
local cut   is to_float(chromosome:substring(192,32)).

function log_telemetry {
  local output is "[".

  // Time
  set output to output + (time:seconds - start_time) + ",".

  // Altitude
  set output to output + alt:radar + ",".

  // Angle
  set angle to 90 - vang(up:vector, ship:facing:vector).
  set output to output + angle + ",".

  // Apoapsis
  set output to output + apoapsis + ",".

  // Eccentricity
  set output to output + obt:eccentricity + ",".

  // DeltaV
  list engines in ship_engines.
  set dry_mass to ship:mass - ((ship:liquidfuel + ship:oxidizer) * 0.005).
  set delta_v to ship_engines[0]:isp * 9.81 * ln(ship:mass / dry_mass).
  set output to output + delta_v + ",".

  // Target Pitch
  set output to output + pitch + ",".

  // Target Throttle
  set output to output + throttle + "],".

  log output to ascent.js.
}

log "" to ascent.js. delete ascent.js.
log "var data = [['Time','Altitude','Angle','Apoapsis','Eccentrity','DeltaV','Target Pitch','Target Throttle']," to ascent.js.

// Launch
lock throttle to 1.
lock steering to heading(90, 90).
stage. wait 5.

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
  if addons:rt:hasconnection(ship) log_telemetry().
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
if not addons:rt:hasconnection(ship) { lights on. wait until addons:rt:hasconnection(ship). }
log "];" to ascent.js.
