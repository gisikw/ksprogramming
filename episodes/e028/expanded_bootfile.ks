// Revised Boot Script v0.0.1
// Kevin Gisi
// http://youtube.com/gisikw

function build_command_filename {
  parameter n.
  return n + ".update.ks".
}

function core_has_tagname {
  return core:part:tag <> "".
}

function assign_core_tagname {
  local n is "".
  until n:length = 14 {
    set n to n + (random() + ""):remove(0,2).
    if n:length > 14 set n to n:substring(0, 14).
  }
  set core:part:tag to n.
}

function command_name {
  if not core_has_tagname() assign_core_tagname().
  return build_command_filename(core:part:tag).
}

function has_file {
  parameter n.
  list files in fs.
  for f in fs if f:name = n return 1.
  return 0.
}

function has_new_command {
  if not addons:rt:hasconnection(ship) return 0.
  switch to 0.
  local result is has_file(command_name()).
  switch to 1.
  return result.
}

function has_startup_script { return has_file("startup.ks"). }
function run_startup_script { run startup.ks. }
function fetch_new_command { copy command_name() from 0. }

function fetch_and_run_new_command {
  fetch_new_command().
  run_new_command().
}

function run_new_command {
  log "" to tmp.exec.ks. delete tmp.exec.ks.
  rename command_name() to "tmp.exec.ks".
  run tmp.exec.ks.
}

// Bootup process
set ship:control:pilotmainthrottle to 0.
if has_new_command() fetch_and_run_new_command().
else if has_startup_script() run_startup_script().
