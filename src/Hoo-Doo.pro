/* -*- Mode:Prolog; coding:iso-8859-1; -*- */



%%%%%3x3 [[a,b,c],[d,e,f],[g,h,i]]
%%%%%4X4 [[1,a,c,v],[,e,3,4,5],[,a,s,d,y],[l,k,j,h]]

:-include('flat_2D_convert.pro').
:-include('tabPrint.pro').
:-include('custom_all_distinct.pro').
:-use_module(library(timeout)).
:-use_module(library(clpfd)).


test(Bi):-
        generateFlatList(Board,64),
        applyConstraints(Board,8,8,1),
        %sum(Board,#=,Soma),
        count(0,Board,#=,Soma),
        append(Board,[Soma],TodasAsVars),
        labeling([minimize(Soma),down,time_out(800000,Flag)],TodasAsVars),
        fd_statistics,
        inflate(Bi,Board,8,8),
        nl,
        print_tab(Bi), nl,
        write(Flag),
        nl.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkValidSize(0, _, _):-!, halt.
checkValidSize(_, 0, _):-!, halt.
checkValidSize(NLines, NColumns, Status):-
        number(NLines),
        number(NColumns),
        NLines > 0,
        NLines < 25,
        NColumns > 0,
        NColumns < 25,
        Status=ok.




executeMenuCommand('1',ok).
executeMenuCommand('2',ok):-!, halt.
executeMenuCommand(Input,Output):- !,Input\=2,Input\=1,Output=bad.


menu:-
        write('1- Choose board sizes\n'),
        write('2- Exit\n').


getSize(NLines, NColumns):-
        write('Write the number of lines you want followed by ".",\nWrite 0 to exit'), nl,
        read(NLines), nl,
        write('Write the number of columns you want followed by "."\nWrite 0 to exit'), nl,
        read(NColumns), nl.


isValidTransparency('0', 0).
isValidTransparency('1', 1).
isValidTransparency('2', _):-!, halt.
isValidTransparency(_, bad).

getTransparency(Transparency):-
        write('Do you wish to solve with transparent pegs?\n'),
        write('0- No Transparent pegs\n1-With transparent pegs\n2-Exit\n'),
        get_char(_),
        get_char(Option),
        get_char(_),
        isValidTransparency(Option, Transparency),
        Option \=bad;
        !,
        write('Invalid Option, try again\n'),
        getTransparency(Transparency).
        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Game Start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




start:-
        write('############Hoo-Doo##########\n'), nl,
        menu, !,
        get_char(Input),
        get_char(_), %consume enter key
        executeMenuCommand(Input,Output),
        Output=ok,
        getSize(NLines, NColumns),
        !,
        checkValidSize(NLines, NColumns, Is_ok),
        Is_ok= ok,
        getTransparency(Transparency),
        Transparency \= bad,
        solve(SolveBoard, NLines, NColumns , Transparency), !,
        print_tab(SolveBoard);
        write('You chose an invalid option or board size\n\n\n'),
        !,
        start.


solve(SolvedBoard,NrLines,NrColumns,TransparentMode):-
        DesiredSize is NrLines*NrColumns,%plus one for the Transparent
        generateFlatList(Board,DesiredSize),
        applyConstraints(Board,NrLines,NrColumns,TransparentMode),
        labeling([], Board),
        inflate(SolvedBoard, Board, NrLines, NrColumns).


        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate List
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
generateFlatList(Board,DesiredSize):-
        Index is 0,
        generateFlatListAux(DesiredSize, Index, [], Board).
        
        
generateFlatListAux(DesiredSize, DesiredSize, Board, Board).

generateFlatListAux(DesiredSize, Index, Progress, Board):-
                append(Progress, [_], Nprogress),
                Next_index is Index+1,
                generateFlatListAux(DesiredSize,Next_index, Nprogress, Board).
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Hoo-Doo Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

applyConstraints(FlatBoard,NrLines,NrColumns,UseTransparent):-
        max_member(UpperValue,[NrColumns,NrLines]),
        %apply domain constraints
        (UseTransparent = 0,!,domain(FlatBoard,1,UpperValue);domain(FlatBoard,0,UpperValue)),
        inflate(Inflated, FlatBoard,NrLines,NrColumns),
        applyLineConstraints(Inflated,UseTransparent),
        applyColumnConstraints(Inflated,NrColumns,UseTransparent),
        applyDiagonalConstraints(Inflated,NrLines,NrColumns,UseTransparent).

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Line Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
applyLineConstraints([BoardHead|BoardTail],UseTransparent):-
        custom_all_distinct(BoardHead,UseTransparent,0),
        !,
        applyLineConstraints(BoardTail,UseTransparent).

applyLineConstraints([],_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getColumn(Board,Col,ColNr):-
        getColumn(Board,Col,ColNr,[]).

getColumn([BoardHead|BoardTail],Col,ColNr,Tmp):-
        nth0(ColNr,BoardHead,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getColumn(BoardTail,Col,ColNr,NewTmp).
getColumn([],Col,_,Tmp):-
        Col = Tmp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Column Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


applyColumnConstraints(Board,NrColumns,UseTransparent):-
        applyColumnConstraints(Board,NrColumns,0,UseTransparent).

applyColumnConstraints(Board,NrColumns,Nr,UseTransparent):-
        Nr<NrColumns,
        getColumn(Board,Col,Nr),
        custom_all_distinct(Col,UseTransparent,0),
        NewNr is Nr+1,
        !,
        applyColumnConstraints(Board,NrColumns,NewNr,UseTransparent).
applyColumnConstraints(_,NrColumns,NrColumns,_).


        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find l Diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getlDiagonalStartingPosition(Side,DiagonalNr,Line,Col):-
        (DiagonalNr>=Side, Pos is (DiagonalNr mod Side)+1;Pos is (Side-DiagonalNr-1)*Side),
        Line is Pos // Side,
        Col is  Pos mod Side,
        !.


getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr):-
        max_member(Max,[NrLines,NrColumns]),
        getlDiagonalStartingPosition(Max,DiagonalNr,Line,Col),%get position for the square containing the board
        !,
        getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,[],Line,Col).


%case where the position is outside the board and the square containing it
getLDiagonal(NrLines,NrColumns,_,Diagonal,_,Tmp,CurrentCol,CurrentLine):-
        max_member(Max,[NrLines,NrColumns]),
        (CurrentCol>=Max;CurrentLine>=Max),
        !,
        Diagonal=Tmp.%just return what you have so far



getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        CurrentLine<NrLines,CurrentCol<NrColumns,
        CurrentLine>=0,CurrentCol>=0,
        NewCol is CurrentCol+1,
        NewLine is CurrentLine+1,
        nth0(CurrentLine,Board,Line),
        nth0(CurrentCol,Line,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,NewTmp,NewLine,NewCol).


%case where it is outside the board but not outside the square that constains it probably 
%because the initial point of the diagonal is in a position that is not present in this 
%board but only on the square that contains it. Remember that getlDiagonalStartingPosition 
%gets the position in the square that constains the board not the board itself
%being so it may happen that the initial position is outside the board

getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentCol,CurrentLine):-
        NewCol is CurrentCol+1,
        NewLine is CurrentLine+1,
        %just increment position hoping it will get inside the board
        !,
        getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,NewLine,NewCol).
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find r Diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        
getrDiagonalStartingPosition(Side,DiagonalNr,Line,Col):-
        (DiagonalNr<Side,Pos=DiagonalNr;DiagonalNr>=Side,Pos is (DiagonalNr-Side+2)*Side-1),
        Line is Pos // Side,
        Col is  Pos mod Side,
        !.


%refer to getLDiagonal for comments on the implementation (they are the same for both cases)

%both both predicates are similar, differing only on the increment function for NewLine and NewCol
%that defines the next position in the diagonal

getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr):-
        max_member(Max, [NrLines,NrColumns]),
        getrDiagonalStartingPosition(Max,DiagonalNr,StartingLine,StartingCol),
        getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,[],StartingLine,StartingCol).

getRDiagonal(NrLines,NrColumns,_,Diagonal,_,Tmp,CurrentLine,CurrentCol):-
        max_member(Max,[NrLines,NrColumns]),
        (CurrentLine<0;CurrentCol<0;CurrentLine>=Max;CurrentCol>=Max),
        !,
        Diagonal=Tmp.

getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        CurrentLine<NrLines,CurrentCol<NrColumns,
        CurrentLine>=0,CurrentCol>=0,
        NewLine is CurrentLine+1,
        NewCol is CurrentCol-1,
        nth0(CurrentLine,Board,Line),
        nth0(CurrentCol,Line,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,NewTmp,NewLine,NewCol).

getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        NewLine is CurrentLine+1,
        NewCol is CurrentCol-1,
        !,
        getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,NewLine,NewCol).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Apply Diagonal Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


applyDiagonalConstraints(Board,NrLines,NrColumns,UseTransparent):-
        applyRDiagonalConstraints(Board,NrLines,NrColumns,1,UseTransparent),
        applyLDiagonalConstraints(Board,NrLines,NrColumns,1,UseTransparent).


applyRDiagonalConstraints(Board,NrLines,NrColumns,DiagonalNr,UseTransparent):-
        max_member(Max,[NrLines,NrColumns]),
        DiagonalNr<2*Max-2,
        NextDiagonalNr is DiagonalNr +1,
        getRDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr),
        custom_all_distinct(Diagonal,UseTransparent,0),
        !,
        applyRDiagonalConstraints(Board,NrLines,NrColumns,NextDiagonalNr,UseTransparent).
applyRDiagonalConstraints(_,NrLines,NrColumns,DiagonalNr,_):-
        max_member(Max,[NrLines,NrColumns]),
        DiagonalNr>=2*Max-2.


applyLDiagonalConstraints(Board,NrLines,NrColumns,DiagonalNr,UseTransparent):-
        max_member(Max,[NrLines,NrColumns]),
        DiagonalNr<2*Max-2,
        NextDiagonalNr is DiagonalNr +1,
        getLDiagonal(NrLines,NrColumns,Board,Diagonal,DiagonalNr),
        custom_all_distinct(Diagonal,UseTransparent,0),
        !,
        applyLDiagonalConstraints(Board,NrLines,NrColumns,NextDiagonalNr,UseTransparent).
applyLDiagonalConstraints(_,NrLines,NrColumns,DiagonalNr,_):-
        max_member(Max,[NrLines,NrColumns]),
        DiagonalNr>=2*Max-2.


%       TODO non square version!!!!!!
