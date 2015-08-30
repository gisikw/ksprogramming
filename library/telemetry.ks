// Ship's delta v
FUNCTION TLM_DELTAV {
  LIST ENGINES IN shipEngines.
  SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
  RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Time to impact
FUNCTION TLM_TTI {
  PARAMETER margin.

  LOCAL d IS ALT:RADAR - margin.
  LOCAL v IS -SHIP:VERTICALSPEED.
  LOCAL g IS SHIP:BODY:MU / SHIP:BODY:RADIUS^2.

  RETURN (SQRT(v^2 + 2 * g * d) - v) / g.
}
