run docking.ks.
rcs on.
dok_ensure_range(vessel("KSS"), ship:partstagged("DrivePort")[0], 250, 20).
dok_dock("DrivePort", "KSS", "TugboatPort").
