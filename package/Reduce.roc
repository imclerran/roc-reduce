module [
    list_left,
    reduce_list_left,
    list_right,
    reduce_list_right,
    dict,
    reduce_dict,
    dict_keys,
    reduce_dict_keys,
    dict_values,
    reduce_dict_values,
    set,
    reduce_set,
]

## Reduce a list to a single value of the same type starting with the first element
list_left : List a, (a, a -> a) -> Result a [ListWasEmpty]
list_left = |l, f|
    when l is
        [x, .. as xs] -> List.walk(xs, x, f) |> Ok
        [] -> Err(ListWasEmpty)

## More descriptive name for unqualified use
reduce_list_left = list_left

expect reduce_list_left([], Num.add) == Err(ListWasEmpty)
expect reduce_list_left([5], Num.add) == Ok(5)
expect reduce_list_left([1, 2, 3], Num.add) == Ok(6)

## Reduce a list to a single value of the same type starting with the last element
list_right : List a, (a, a -> a) -> Result a [ListWasEmpty]
list_right = |l, f|
    when l is
        [.. as xs, x] -> List.walk_backwards(xs, x, f) |> Ok
        [] -> Err(ListWasEmpty)

## More descriptive name for unqualified use
reduce_list_right = list_right

expect reduce_list_right([], Str.concat) == Err(ListWasEmpty)
expect reduce_list_right(["5"], Str.concat) == Ok("5")
expect reduce_list_right(["1", "2", "3"], Str.concat) == Ok("321")

## Reduce a dict to a single tuple, where the tuple contains an element of the key type, and the value type
dict : Dict k v, ((k, v), (k, v) -> (k, v)) -> Result (k, v) [DictWasEmpty]
dict = |d, f|
    when Dict.to_list(d) is
        [x, .. as xs] -> List.walk(xs, x, f) |> Ok
        [] -> Err(DictWasEmpty)

## More descriptive name for unqualified use
reduce_dict = dict

expect
    d = Dict.empty({}) |> Dict.insert("a", 1) |> Dict.insert("b", 2) |> Dict.insert("c", 3)
    res = reduce_dict(d, |(k1, v1), (k2, v2)| (Str.concat(k1, k2), Num.add(v1, v2)))
    res == Ok(("abc", 6))

## Reduce a dict to a single value of the same type as the key type
dict_keys : Dict k v, (k, k -> k) -> Result k [DictWasEmpty]
dict_keys = |d, f|
    fk = |acc, (k, _)| f(acc, k)
    when Dict.to_list(d) is
        [(k, _), .. as ks] -> List.walk(ks, k, fk) |> Ok
        [] -> Err(DictWasEmpty)

## More descriptive name for unqualified use
reduce_dict_keys = dict_keys

expect
    d = Dict.empty({}) |> Dict.insert("a", 1) |> Dict.insert("b", 2) |> Dict.insert("c", 3)
    res = reduce_dict_keys(d, Str.concat)
    res == Ok("abc")

## Reduce a dict to a single value of the same type as the value type
dict_values : Dict k v, (v, v -> v) -> Result v [DictWasEmpty]
dict_values = |d, f|
    fv = |acc, (_, v)| f(acc, v)
    when Dict.to_list(d) is
        [(_, v), .. as vs] -> List.walk(vs, v, fv) |> Ok
        [] -> Err(DictWasEmpty)

## More descriptive name for unqualified use
reduce_dict_values = dict_values

expect
    d = Dict.empty({}) |> Dict.insert("a", 1) |> Dict.insert("b", 2) |> Dict.insert("c", 3)
    res = reduce_dict_values(d, Num.add)
    res == Ok(6)

## Reduce a set to a single value of the same type as the element type
set : Set a, (a, a -> a) -> Result a [SetWasEmpty]
set = |s, f|
    when Set.to_list(s) is
        [x, .. as xs] -> List.walk(xs, x, f) |> Ok
        [] -> Err(SetWasEmpty)

## More descriptive name for unqualified use
reduce_set = set

expect
    s = Set.empty({}) |> Set.insert("a") |> Set.insert("b") |> Set.insert("c")
    res = reduce_set(s, Str.concat)
    res == Ok("abc")
