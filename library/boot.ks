// Generalized Boot Script v1.0.1
// Kevin Gisi
// http://youtube.com/gisikw

// The ship will use updateScript to check for new commands from KSC.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

// Display a message
FUNCTION NOTIFY {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, YELLOW, false).
}

// Detect whether a file exists on the specified volume
FUNCTION HAS_FILE {
  PARAMETER name.
  PARAMETER vol.

  SWITCH TO vol.
  LIST FILES IN allFiles.
  FOR file IN allFiles {
    IF file:NAME = name {
      SWITCH TO 1.
      RETURN TRUE.
    }
  }

  SWITCH TO 1.
  RETURN FALSE.
}

// First-pass at introducing artificial delay. ADDONS:RT:DELAY(SHIP) represents
// the line-of-site latency to KSC, as per RemoteTech
FUNCTION DELAY {
  SET dTime TO ADDONS:RT:DELAY(SHIP) * 3. // Total delay time
  SET accTime TO 0.                       // Accumulated time

  UNTIL accTime >= dTime {
    SET start TO TIME:SECONDS.
    WAIT UNTIL (TIME:SECONDS - start) > (dTime - accTime) OR NOT ADDONS:RT:HASCONNECTION(SHIP).
    SET accTime TO accTime + TIME:SECONDS - start.
  }
}

// Get a file from KSC
FUNCTION DOWNLOAD {
  PARAMETER name.

  DELAY().
  IF HAS_FILE(name, 1) {
    DELETE name.
  }
  IF HAS_FILE(name, 0) {
    COPY name FROM 0.
  }
}

// Put a file on KSC
FUNCTION UPLOAD {
  PARAMETER name.

  DELAY().
  IF HAS_FILE(name, 0) {
    SWITCH TO 0. DELETE name. SWITCH TO 1.
  }
  IF HAS_FILE(name, 1) {
    COPY name TO 0.
  }
}

// Run a library, downloading it from KSC if necessary
FUNCTION REQUIRE {
  PARAMETER name.

  IF NOT HAS_FILE(name, 1) { DOWNLOAD(name). }
  RENAME name TO "tmp.exec.ks".
  RUN tmp.exec.ks.
  RENAME "tmp.exec.ks" TO name.
}

// THE ACTUAL BOOTUP PROCESS
SET updateScript TO SHIP:NAME + ".update.ks".

// If we have a connection, see if there are new instructions. If so, download
// and run them.
IF ADDONS:RT:HASCONNECTION(SHIP) {
  IF HAS_FILE(updateScript, 0) {
    DOWNLOAD(updateScript).
    SWITCH TO 0. DELETE updateScript. SWITCH TO 1.
    IF HAS_FILE("update.ks", 1) {
      DELETE update.ks.
    }
    RENAME updateScript TO "update.ks".
    RUN update.ks.
    DELETE update.ks.
  }
}

// If a startup.ks file exists on the disk, run that.
IF HAS_FILE("startup.ks", 1) {
  RUN startup.ks.
} ELSE {
  WAIT UNTIL ADDONS:RT:HASCONNECTION(SHIP).
  WAIT 10. // Avoid thrashing the CPU (when no startup.ks, but we have a
           // persistent connection, it will continually reboot).
  REBOOT.
}
