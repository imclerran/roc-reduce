module [
    listLeft, 
    reduceListLeft,
    listRight, 
    reduceListRight,
    dict, 
    reduceDict,
    dictKeys, 
    reduceDictKeys,
    dictValues, 
    reduceDictValues,
    set,
    reduceSet,
]

## Reduce a list to a single value of the same type starting with the first element
listLeft : List a, (a, a -> a) -> Result a [ListWasEmpty]
listLeft = \l, f ->
    when l is
        [x, .. as xs] -> List.walk xs x f |> Ok
        [] -> Err ListWasEmpty

## More descriptive name for unqualified use
reduceListLeft = listLeft

expect reduceListLeft [] Num.add == Err ListWasEmpty
expect reduceListLeft [5] Num.add == Ok 5
expect reduceListLeft [1, 2, 3] Num.add == Ok 6

## Reduce a list to a single value of the same type starting with the last element
listRight : List a, (a, a -> a) -> Result a [ListWasEmpty]
listRight = \l, f ->
    when l is
        [.. as xs, x] -> List.walkBackwards xs x f |> Ok
        [] -> Err ListWasEmpty

## More descriptive name for unqualified use
reduceListRight = listRight

expect reduceListRight [] Str.concat == Err ListWasEmpty
expect reduceListRight ["5"] Str.concat == Ok "5"
expect reduceListRight ["1", "2", "3"] Str.concat == Ok "321"

## Reduce a dict to a single tuple, where the tuple contains an element of the key type, and the value type
dict : Dict k v, ((k, v), (k, v) -> (k, v)) -> Result (k, v) [DictWasEmpty]
dict = \d, f ->
    when Dict.toList d is
        [x, .. as xs] -> List.walk xs x f |> Ok
        [] -> Err DictWasEmpty

## More descriptive name for unqualified use
reduceDict = dict

expect
    d = Dict.empty {} |> Dict.insert "a" 1 |> Dict.insert "b" 2 |> Dict.insert "c" 3
    res = reduceDict d \(k1, v1), (k2, v2) -> (Str.concat k1 k2, Num.add v1 v2)
    res == Ok ("abc", 6)

## Reduce a dict to a single value of the same type as the key type
dictKeys : Dict k v, (k, k -> k) -> Result k [DictWasEmpty]
dictKeys = \d, f ->
    fk = \acc, (k, _) -> f acc k
    when Dict.toList d is
        [(k, _), .. as ks] -> List.walk ks k fk |> Ok
        [] -> Err DictWasEmpty

## More descriptive name for unqualified use
reduceDictKeys = dictKeys

expect
    d = Dict.empty {} |> Dict.insert "a" 1 |> Dict.insert "b" 2 |> Dict.insert "c" 3
    res = reduceDictKeys d Str.concat
    res == Ok "abc"

## Reduce a dict to a single value of the same type as the value type
dictValues : Dict k v, (v, v -> v) -> Result v [DictWasEmpty]
dictValues = \d, f ->
    fv = \acc, (_, v) -> f acc v
    when Dict.toList d is
        [(_, v), .. as vs] -> List.walk vs v fv |> Ok
        [] -> Err DictWasEmpty

## More descriptive name for unqualified use
reduceDictValues = dictValues

expect
    d = Dict.empty {} |> Dict.insert "a" 1 |> Dict.insert "b" 2 |> Dict.insert "c" 3
    res = reduceDictValues d Num.add
    res == Ok 6

## Reduce a set to a single value of the same type as the element type
set : Set a, (a, a -> a) -> Result a [SetWasEmpty]
set = \s, f ->
    when Set.toList s is
        [x, .. as xs] -> List.walk xs x f |> Ok
        [] -> Err SetWasEmpty

## More descriptive name for unqualified use
reduceSet = set

expect
    s = Set.empty {} |> Set.insert "a" |> Set.insert "b" |> Set.insert "c"
    res = reduceSet s Str.concat
    res == Ok "abc"