import gleam/int
import gleam/list
import gleam/regexp
import gleam/string

pub type Point {
  Point(x: Int, y: Int)
}

pub type Machine {
  Machine(a: Point, b: Point, prize: Point)
}

pub fn pt_1(input: String) {
  let machines =
    string.split(input, on: "\n\n")
    |> list.map(fn(l) {
      let assert Ok(re) = regexp.from_string("\\d+")

      let assert [a, b, prize] =
        regexp.scan(with: re, content: l)
        |> list.filter_map(fn(m) { int.parse(m.content) })
        |> list.sized_chunk(into: 2)
        |> list.map(fn(c) {
          let assert [x, y] = c
          Point(x, y)
        })

      Machine(a, b, prize)
    })

  list.fold(machines, 0, fn(cost, m) { cost + calc_min_cost(m) })
}

pub fn pt_2(input: String) {
  let machines =
    string.split(input, on: "\n\n")
    |> list.map(fn(l) {
      let assert Ok(re) = regexp.from_string("\\d+")

      let assert [a, b, prize] =
        regexp.scan(with: re, content: l)
        |> list.filter_map(fn(m) { int.parse(m.content) })
        |> list.sized_chunk(into: 2)
        |> list.map(fn(c) {
          let assert [x, y] = c
          Point(x, y)
        })

      Machine(
        a,
        b,
        Point(prize.x + 10_000_000_000_000, prize.y + 10_000_000_000_000),
      )
    })

  list.fold(machines, 0, fn(cost, m) { cost + calc_min_cost(m) })
}

fn calc_min_cost(m: Machine) -> Int {
  let b =
    { m.prize.y * m.a.x - m.prize.x * m.a.y }
    / { m.b.y * m.a.x - m.b.x * m.a.y }
  let a = { m.prize.x - b * m.b.x } / m.a.x

  case
    #(m.a.x * a + m.b.x * b, m.a.y * a + m.b.y * b) != #(m.prize.x, m.prize.y)
  {
    True -> 0
    False -> a * 3 + b
  }
}
