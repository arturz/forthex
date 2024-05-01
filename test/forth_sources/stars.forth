( n1 -- )
: STARS   0 DO 42 EMIT LOOP ;

( n1 -- )
: \STARS   0 DO
    CR
    I SPACES
    10 STARS
    LOOP ;

( n1 -- )
: /STARS   DUP 0 DO
    CR
    DUP I - SPACES
    10 STARS
    LOOP DROP ;

( n1 -- )
: \STARS2   DUP BEGIN
    CR
    2DUP - SPACES
    10 STARS
    1 -
    DUP 0 = UNTIL 2DROP ;
