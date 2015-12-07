// VectorTest2 v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION translate {
  PARAMETER vector.
  SET vector TO vector:normalized.

  SET SHIP:CONTROL:STARBOARD  TO vector * SHIP:FACING:STARVECTOR.
  SET SHIP:CONTROL:FORE       TO vector * SHIP:FACING:FOREVECTOR.
  SET SHIP:CONTROL:TOP        TO vector * SHIP:FACING:TOPVECTOR.
}

RCS ON.
FOR x IN LIST(-1, 0, 1) {
  FOR y IN LIST(-1, 0, 1) {
    FOR z IN LIST(-1, 0, 1) {
      LOCAL testVector IS V(x, y, z).
      CLEARVECDRAWS().
      VECDRAW(
        V(0,0,0),
        testVector,
        RGB(1,0,0),
        "Test Vector",
        5.0,
        TRUE
      ).
      translate(testVector).
      WAIT 10.
    }
  }
}
