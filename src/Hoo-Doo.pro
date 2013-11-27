/* -*- Mode:Prolog; coding:iso-8859-1; -*- */

/* -*- Mode:Prolog; coding:iso-8859-1; -*- */


generateInitialBoard(Side,B):-
        generateInitialBoard(Side,0,[],B).

generateInitialBoard(Side,Nr,Tmp,B):-
        SideSquare is Side*Side,
        Nr<SideSquare,
        append(Tmp,[_X],NewTmp),
        NewNr is Nr+1,
        !,generateInitialBoard(Side,NewNr,NewTmp,B).

generateInitialBoard(Side,Nr,Tmp,B):-
        SideSquare is Side*Side,
        Nr = SideSquare,
        B = Tmp.

%convert a flatten board to a bidimentional one
inflate(Bidimentional,Flatten,Side):-
        inflate(Bidimentional,Flatten,[],Side).
        



test(B):-
        generateInitialBoard(3,B).
        