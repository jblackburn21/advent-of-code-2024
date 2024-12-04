import gleam/int
import gleam/list
import gleam/pair
import gleam/string

pub fn pt_1(input: String) {
  string.split(input, on: "\n")
  |> list.map(parse_levels(_))
  |> list.map(list.window_by_2(_))
  |> list.count(fn(l) {
    check_all_safe(l) || reverse_levels(l) |> check_all_safe()
  })
}

pub fn pt_2(input: String) {
  string.split(input, on: "\n")
  |> list.map(parse_levels(_))
  |> list.map(fn(r) {
    list.combinations(r, list.length(r) - 1)
    |> list.prepend(r)
    |> list.map(list.window_by_2(_))
  })
  |> list.count(fn(r) {
    list.any(r, check_all_safe(_))
    || list.map(r, reverse_levels(_)) |> list.any(check_all_safe(_))
  })
}

fn check_all_safe(levels: List(#(Int, Int))) -> Bool {
  list.all(levels, is_safe_level(_))
}

fn parse_levels(row: String) -> List(Int) {
  string.split(row, on: " ") |> list.filter_map(int.parse)
}

fn is_safe_level(p: #(Int, Int)) -> Bool {
  let is_increasing = p.0 < p.1
  let is_more_than_zero = p.1 - p.0 > 0
  let is_less_than_four = p.1 - p.0 < 4

  // io.println(int.to_string(p.0) <> " " <> int.to_string(p.1))

  is_increasing && is_more_than_zero && is_less_than_four
}

fn reverse_levels(levels: List(#(Int, Int))) -> List(#(Int, Int)) {
  list.reverse(levels) |> list.map(pair.swap)
}
