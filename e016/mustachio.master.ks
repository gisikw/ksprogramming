// Mustachio Master Script
// Kevin Gisi
// http://youtube.com/gisikw

// Libraries
DOWNLOAD("lib_pid.ks").
DOWNLOAD("maneuver.ks").
DOWNLOAD("orbit.ks").
DOWNLOAD("telemetry.ks").

// Mission Scripts
DOWNLOAD("mustachio.launch.ks").
DOWNLOAD("mustachio.transfer.ks").
DOWNLOAD("mustachio.landing.ks").

NOTIFY("Mustachio Mission Ready").  WAIT 5.
NOTIFY("Commencing in 10s").        WAIT 10.

RUN mustachio.launch.ks.    // Get the craft to orbit
RUN mustachio.transfer.ks.  // Transfer to the Mun
RUN mustachio.landing.ks.   // Land on the Mun

WAIT 30.
NOTIFY("Going into low-power mode").
LIGHTS OFF.
