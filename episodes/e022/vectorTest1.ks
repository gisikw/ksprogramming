// VectorTest1 v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

ON SAS {
  CLEARVECDRAWS().

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:FOREVECTOR,
    RGB(1,0,0),
    "Fore Vector",
    5.0,
    TRUE
  ).

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:STARVECTOR,
    RGB(0,1,0),
    "Star Vector",
    5.0,
    TRUE
  ).

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:TOPVECTOR,
    RGB(0,0,1),
    "Top Vector",
    5.0,
    TRUE
  ).

  PRESERVE.
}

ON RCS {
  CLEARVECDRAWS().

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:FOREVECTOR,
    RGB(1,0,0),
    "Fore Vector",
    10.0,
    TRUE
  ).

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:STARVECTOR,
    RGB(0,1,0),
    "Star Vector",
    10.0,
    TRUE
  ).

  VECDRAW(
    V(0,0,0),
    SHIP:FACING:TOPVECTOR,
    RGB(0,0,1),
    "Top Vector",
    10.0,
    TRUE
  ).

  PRESERVE.
}

WAIT UNTIL FALSE.
