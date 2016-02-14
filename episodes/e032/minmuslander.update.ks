// Minmus Lander
// Kevin Gisi
// http://youtube.com/gisikw

function main {
  perform_ascent().
  perform_circularization().
  transfer_to(Minmus).
  perform_powered_descent().
  gather_science().
  perform_ascent().
  perform_circularization().
  transfer_to(Kerbin).
  perform_unpowered_descent().
}

function perform_ascent {
  // TODO
}

function perform_circularization {
  // TODO
}

function transfer_to {
  parameter body.
  // TODO
}

function perform_powered_descent {
  // TODO
}

function gather_science {
  // TODO
}

function perform_unpowered_descent {
  // TODO
}

main().
