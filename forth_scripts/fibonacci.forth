: FIBONACCI ( i -- n_1..n_i )
  0 1 ROT 0 DO
    2DUP
    +
  LOOP .s ; 
