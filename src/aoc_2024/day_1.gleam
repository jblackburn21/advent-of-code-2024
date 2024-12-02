import gleam/dict
import gleam/int
import gleam/io

// import gleam/io
import gleam/list
import gleam/string

pub fn pt_1(input: String) {
  let rows =
    input
    |> string.split(on: "\n")
    |> list.map(fn(r) {
      string.split(r, on: "   ")
      |> list.filter_map(int.parse)
    })

  let left =
    rows
    |> list.filter_map(list.first)
    |> list.sort(by: int.compare)

  let right =
    rows
    |> list.filter_map(list.last)
    |> list.sort(by: int.compare)

  list.map2(left, right, fn(l, r) {
    let distance = int.absolute_value(r - l)

    // io.println(
    //   string.concat([
    //     "Left: ",
    //     int.to_string(l),
    //     ", Right: ",
    //     int.to_string(r),
    //     ", Distance: ",
    //     int.to_string(distance),
    //   ]),
    // )

    distance
  })
  |> int.sum
}

pub fn pt_2(input: String) {
  let rows =
    input
    |> string.split(on: "\n")
    |> list.map(fn(r) {
      string.split(r, on: "   ")
      |> list.filter_map(int.parse)
    })

  let left =
    rows
    |> list.filter_map(list.first)

  let right =
    rows
    |> list.filter_map(list.last)

  left
  |> list.map(fn(l) {
    let c = list.count(right, fn(r) { r == l })

    let s = l * c

    io.println(int.to_string(s))

    s
  })
  |> int.sum
}
// 9 + 4 + 0 + 0 + 9 + 9
