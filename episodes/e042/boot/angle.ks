function geo_offset {
  parameter geo, n_offset, e_offset.
  return latlng(
    geo:lat + (n_offset / body:radius * 180 / constant:pi / cos(geo:lat)),
    geo:lng + (e_offset / body:radius * 180 / constant:pi / cos(geo:lat))
  ).
}

function get_plane {
  parameter x is 0, y is 0.
  local center is geo_offset(ship:geoposition, x, y).
  set a_spot to geo_offset(center, 5, 0).
  set b_spot to geo_offset(center, -5, 5).
  set c_spot to geo_offset(center, -5, -5).

  set a_vec to a_spot:altitudeposition(a_spot:terrainheight).
  set b_vec to b_spot:altitudeposition(b_spot:terrainheight).
  set c_vec to c_spot:altitudeposition(c_spot:terrainheight).

  set a to vecdraw(a_vec,
                   up:vector,
                   red, "", 1, true).
  set b to vecdraw(b_vec,
                   up:vector,
                   red, "", 1, true).
  set c to vecdraw(c_vec,
                   up:vector,
                   red, "", 1, true).

  set slope to vcrs(b_vec - a_vec, c_vec - a_vec):normalized.
  set slope_draw to vecdraw(center:altitudeposition(center:terrainheight),
                            slope,
                            green, "", 10, true).
  print "Angle: " + vang(slope, up:vector).
}

local x is 0. local y is 0.
get_plane(x, y).
on ag1 { set x to x + 1. get_plane(x, y). preserve. }
on ag2 { set x to x - 1. get_plane(x, y). preserve. }
on ag3 { set y to y + 1. get_plane(x, y). preserve. }
on ag4 { set y to y - 1. get_plane(x, y). preserve. }

wait until rcs.
clearvecdraws().
rcs off.
