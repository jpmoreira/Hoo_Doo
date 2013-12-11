
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print Solution Board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


tab_map(x):- write(' ').
tab_map(NUM):- write(NUM).



print_line([X|[]]):- 
  X < 10,
    write('|  '),
    tab_map(X),
    write(' |').
  
print_line([X|[]]):- 
  X >= 10,
    write('| '),
    tab_map(X),
    write(' |').



print_line([X|Xs]):-
  X < 10,
    write('|  '),
    tab_map(X),
    write(' '),
    print_line(Xs).

print_line([X|Xs]):-
  X >= 10,
    write('| '),
    tab_map(X),
    write(' '),
    print_line(Xs).




print_empty_line(0):-
        write('-----').

print_empty_line(Len):-
      Len > 0,
      write('----'),
      LenNext is Len - 1,
      print_empty_line(LenNext).




print_column_index(_,0):- nl.
print_column_index(ASCIICode,I):-
      I > 0,
      
      char_code(C,ASCIICode),
      write(C), write('    '),
      
      ASCIICodeNext is ASCIICode + 1,
      Inext         is I - 1,
      print_column_index(ASCIICodeNext, Inext).



print_tab_aux([X|[]], 1, Ci):-
  write('   '),
  print_empty_line(Ci), nl,
  write(' '), write(1), write(' '),
  print_line(X), nl,
  write('   '),
  print_empty_line(Ci), nl,
  write('      '),
  
  char_code('A',ASCIICode),
  Ci1 is Ci-1,
  print_column_index(ASCIICode, Ci1).



print_tab_aux([X|Xs], Li, Ci):-
      Li > 9,

      write('   '),
      print_empty_line(Ci), nl,


      write(Li),
      write(' '),

      print_line(X), nl,

      
      LiNext is Li - 1,
      print_tab_aux(Xs, LiNext, Ci).

print_tab_aux([X|Xs], Li, Ci):-
      Li =< 9,
      write('   '),
      print_empty_line(Ci), nl,

      write(' '), 
      write(Li),
      write(' '),
      
      print_line(X), nl, 
      
      LiNext is Li - 1,
      print_tab_aux(Xs, LiNext, Ci).

print_tab([X|Xs]):-
      length([X|Xs],Vi),
      length(X,Hi),
      Hi1 is Hi+1,
      print_tab_aux([X|Xs], Vi, Hi1).