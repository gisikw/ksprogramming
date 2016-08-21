// Herald Boot Script
// Kevin Gisi
// http://youtube.com/gisikw

{
  for dependency in list(
    "mission_runner.v0.1.0.ks",
    "hillclimb.v0.1.0.ks",
    "transfer.v0.2.1.ks",
    "maneuver.v0.1.0.ks",
    "herald_mission.ks"
  ) if not exists(dependency) copy dependency from 0.

  run mission_runner.v0.1.0.ks.
  run hillclimb.v0.1.0.ks.
  run transfer.v0.2.1.ks.
  run maneuver.v0.1.0.ks.
  run herald_mission.ks.

  run_mission(herald_mission["sequence"], herald_mission["events"]).
}
