%%%%%%%%%%%%%%%%%%%%%%
% search/search.pl

% Entry point: find the shortest sequence of actions (moves + unlocks)
search(Actions) :-
    initial(Start),
    % pick up any key in the starting room
    pickup(Start, [], StartKeys),
    bfs([node(Start, StartKeys, [])], [], Actions).

% bfs(Queue, VisitedStates, SolutionPath)
bfs([node(Room, _, Path) | _], _, Path) :-
    treasure(Room), !.
bfs([node(Room, Keys, _) | Rest], Visited, Actions) :-
    member(state(Room, Keys), Visited), !,
    bfs(Rest, Visited, Actions).
bfs([node(Room, Keys, Path) | Rest], Visited, Actions) :-
    findall(
        node(NextRoom, NextKeys, NewPath),
        (
            next_state(Room, Keys, NextRoom, NextKeys, StepActions),
            append(Path, StepActions, NewPath)
        ),
        Children
    ),
    append(Rest, Children, NewQueue),
    bfs(NewQueue, [state(Room, Keys) | Visited], Actions).

%% next_state/5:
%%   from Room with Keys, you can go to NextRoom, ending up with NextKeys,
%%   performing the sequence StepActions = either [move(...)] or [unlock,move].

% Open (unlocked) door: just move
next_state(Room, Keys, Next, KeysAfter, [move(Room, Next)]) :-
    pickup(Room, Keys, KeysHere),
    ( door(Room, Next)
    ; door(Next, Room)
    ),
    KeysAfter = KeysHere.

% Locked door: unlock first, then move
next_state(Room, Keys, Next, KeysAfter, [unlock(Color), move(Room, Next)]) :-
    pickup(Room, Keys, KeysHere),
    ( locked_door(Room, Next, Color)
    ; locked_door(Next, Room, Color)
    ),
    member(Color, KeysHere),
    KeysAfter = KeysHere.

%% pickup(Room, OldKeys, NewKeys):
%%   collect any key in Room that you dont yet have
pickup(Room, OldKeys, NewKeys) :-
    findall(
        C,
        ( key(Room, C), \+ member(C, OldKeys) ),
        NewColors
    ),
    append(NewColors, OldKeys, NewKeys).
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :- ???
