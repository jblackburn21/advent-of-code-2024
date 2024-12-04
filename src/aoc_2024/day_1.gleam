import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  let assert [left, right] =
    string.split(input, on: "\n")
    |> list.map(fn(r) {
      string.split(r, on: "   ") |> list.filter_map(int.parse)
    })
    |> list.transpose()
    |> list.map(list.sort(_, int.compare))

  list.map2(left, right, fn(l, r) { int.absolute_value(r - l) }) |> int.sum()
}

pub fn pt_2(input: String) {
  let rows =
    string.split(input, on: "\n")
    |> list.map(fn(r) {
      string.split(r, on: "   ") |> list.filter_map(int.parse)
    })

  let left = list.filter_map(rows, list.first)

  let right_groups =
    list.filter_map(rows, list.last)
    |> list.group(fn(r) { r })
    |> dict.map_values(fn(_, r) { list.length(r) })

  list.fold(left, from: 0, with: fn(accum, l) {
    let right_count = dict.get(right_groups, l) |> result.unwrap(0)

    accum + { l * right_count }
  })
}
