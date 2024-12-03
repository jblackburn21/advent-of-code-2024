import gleam/int
import gleam/list
import gleam/pair
import gleam/string

pub fn pt_1(input: String) {
  string.split(input, on: "\n")
  |> list.map(fn(r) {
    string.split(r, on: " ") |> list.filter_map(int.parse) |> list.window_by_2()
  })
  |> list.filter(fn(r) {
    let reversed = list.reverse(r) |> list.map(pair.swap)

    list.all(r, is_safe_level) || list.all(reversed, is_safe_level)
  })
  |> list.length()
}

pub fn pt_2(input: String) {
  string.split(input, on: "\n")
  |> list.map(fn(r) { string.split(r, on: " ") |> list.filter_map(int.parse) })
  |> list.map(fn(r) {
    list.combinations(r, list.length(r) - 1)
    |> list.prepend(r)
    |> list.map(fn(c) { c |> list.window_by_2 })
  })
  |> list.filter(fn(r) {
    let is_safe_increasing = list.any(r, fn(c) { list.all(c, is_safe_level) })
    let is_safe_decreasing =
      list.any(r, fn(c) {
        list.reverse(c) |> list.map(pair.swap) |> list.all(is_safe_level)
      })

    // io.println(
    //   bool.to_string(is_safe_increasing)
    //   <> " "
    //   <> bool.to_string(is_safe_decreasing),
    // )

    is_safe_increasing || is_safe_decreasing
  })
  |> list.length()
}

fn is_safe_level(p: #(Int, Int)) -> Bool {
  let is_increasing = p.0 < p.1
  let is_more_than_zero = p.1 - p.0 > 0
  let is_less_than_four = p.1 - p.0 < 4

  // io.println(int.to_string(p.0) <> " " <> int.to_string(p.1))

  is_increasing && is_more_than_zero && is_less_than_four
}
