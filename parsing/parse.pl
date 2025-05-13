
%%%%%%%%%%%%%%%%%
% Top‐level: succeed exactly when the entire token list is a sequence of Lines
parse(Tokens) :-
    lines(Tokens, []).

% Lines → Line;Lines | Line
lines(Toks, Rest) :-
    line(Toks, Rest1),
    ( Rest1 = [';' | Rest2]
    -> lines(Rest2, Rest)
    ;  Rest1 = Rest
    ).

% Line → Num,Line | Num
line(Toks, Rest) :-
    num(Toks, Rest1),
    ( Rest1 = [',' | Rest2]
    -> line(Rest2, Rest)
    ;  Rest1 = Rest
    ).

% Num → Digit NumTail
num([H|T], Rest) :-
    digit(H),
    num_tail(T, Rest).

% NumTail → Digit NumTail | ε
num_tail([H|T], Rest) :-
    digit(H),
    num_tail(T, Rest).
num_tail(Rest, Rest).

% Digit → '0' .. '9'
digit('0'). digit('1'). digit('2'). digit('3'). digit('4').
digit('5'). digit('6'). digit('7'). digit('8'). digit('9').
%%%%%%%%%%%%%%%%%

parse(X) :- ????

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
