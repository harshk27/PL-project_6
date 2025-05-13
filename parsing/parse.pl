% parse.pl
% Parser for the grammar:
% Lines → Line ; Lines | Line
% Line → Num , Line | Num
% Num → Digit | Digit Num
% Digit → 0 | 1 | ... | 9

% Entry point: succeeds if the entire list of tokens matches the grammar.
parse(Tokens) :-
    lines(Tokens, []).  % no leftover tokens

% Lines → Line ; Lines | Line
lines(Toks, Rest) :-
    line(Toks, Rest1),
    ( Rest1 = [';' | Rest2]
    -> lines(Rest2, Rest)  % Line ; Lines
    ;  Rest1 = Rest        % Line (no semicolon)
    ).

% Line → Num , Line | Num
line(Toks, Rest) :-
    num(Toks, Rest1),
    ( Rest1 = [',' | Rest2]
    -> line(Rest2, Rest)   % Num , Line
    ;  Rest1 = Rest        % Num only
    ).

% Num → Digit NumTail
num([H|T], Rest) :-
    digit(H),
    num_tail(T, Rest).

% NumTail → Digit NumTail | ε
num_tail([H|T], Rest) :-
    digit(H),
    num_tail(T, Rest).
num_tail(Rest, Rest).  % epsilon case

% Digit → '0' | '1' | ... | '9'
digit('0').
digit('1').
digit('2').
digit('3').
digit('4').
digit('5').
digit('6').
digit('7').
digit('8').
digit('9').
