% Entry point: find the shortest sequence of actions (moves + unlocks)
search(Actions) :-
    initial(StartRoom),
    pickup(StartRoom, [], StartKeys),
    bfs([node(StartRoom, StartKeys, [])], [], Actions).

% Breadth-First Search
bfs([node(Room, _, Path) | _], _, Path) :-
    treasure(Room), !.

bfs([node(Room, Keys, _) | Rest], Visited, Actions) :-
    sort(Keys, SortedKeys),
    member(state(Room, SortedKeys), Visited), !,
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
    sort(Keys, SortedKeys),
    append(Rest, Children, NewQueue),
    bfs(NewQueue, [state(Room, SortedKeys) | Visited], Actions).

% next_state/5:
% Given current Room and Keys, produce a valid next move and updated keys

% Case 1: Move through an unlocked door
next_state(Room, Keys, Next, KeysAfter, [move(Room, Next)]) :-
    (door(Room, Next) ; door(Next, Room)),
    pickup(Next, Keys, KeysAfter).

% Case 2: Unlock a door and move through it
next_state(Room, Keys, Next, KeysAfter, [unlock(Color), move(Room, Next)]) :-
    (locked_door(Room, Next, Color) ; locked_door(Next, Room, Color)),
    member(Color, Keys),
    pickup(Next, Keys, KeysAfter).

% pickup(Room, OldKeys, NewKeys):
% Collect any new key in the room
pickup(Room, OldKeys, NewKeys) :-
    findall(
        Color,
        (key(Room, Color), \+ member(Color, OldKeys)),
        NewColors
    ),
    append(NewColors, OldKeys, TempKeys),
    sort(TempKeys, NewKeys).  % Ensure consistency in key order
