import gleam/dict
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type Point =
  #(Int, Int)

pub fn pt_1(input: String) {
  let matrix =
    string.split(input, on: "\n")
    |> list.map(string.to_graphemes(_))
    |> list.index_map(fn(chars, y) {
      list.index_map(chars, fn(c, x) { pair.new(pair.new(x, y), c) })
    })
    |> list.flatten()
    |> dict.from_list()

  dict.fold(matrix, 0, fn(accum, key, value) {
    case value {
      "X" -> accum + get_pt1_match_count(matrix, key)
      _ -> accum
    }
  })
}

pub fn pt_2(input: String) {
  let matrix =
    string.split(input, on: "\n")
    |> list.map(string.to_graphemes(_))
    |> list.index_map(fn(chars, y) {
      list.index_map(chars, fn(c, x) { pair.new(pair.new(x, y), c) })
    })
    |> list.flatten()
    |> dict.from_list()

  dict.fold(matrix, 0, fn(accum, key, value) {
    case value {
      "A" ->
        accum
        + case has_x_match(matrix, key) {
          True -> 1
          False -> 0
        }
      _ -> accum
    }
  })
}

fn get_pt1_match_count(
  matrix: dict.Dict(Point, String),
  starting_point: Point,
) -> Int {
  let m = matrix
  // Point of X char
  let p = starting_point

  let matches = [
    // right
    check_mas(m, #(p.0 + 1, p.1), #(p.0 + 2, p.1), #(p.0 + 3, p.1)),
    // left
    check_mas(m, #(p.0 - 1, p.1), #(p.0 - 2, p.1), #(p.0 - 3, p.1)),
    // down
    check_mas(m, #(p.0, p.1 + 1), #(p.0, p.1 + 2), #(p.0, p.1 + 3)),
    // down right
    check_mas(m, #(p.0 + 1, p.1 + 1), #(p.0 + 2, p.1 + 2), #(p.0 + 3, p.1 + 3)),
    // down left
    check_mas(m, #(p.0 - 1, p.1 + 1), #(p.0 - 2, p.1 + 2), #(p.0 - 3, p.1 + 3)),
    // up
    check_mas(m, #(p.0, p.1 - 1), #(p.0, p.1 - 2), #(p.0, p.1 - 3)),
    // up right
    check_mas(m, #(p.0 + 1, p.1 - 1), #(p.0 + 2, p.1 - 2), #(p.0 + 3, p.1 - 3)),
    // up left
    check_mas(m, #(p.0 - 1, p.1 - 1), #(p.0 - 2, p.1 - 2), #(p.0 - 3, p.1 - 3)),
  ]

  list.count(matches, fn(m) { m })
}

fn has_x_match(matrix: dict.Dict(Point, String), starting_point: Point) -> Bool {
  let m = matrix
  // Point of A char
  let p = starting_point

  let is_match =
    // M M
    //  A
    // S S
    {
      check_mas(m, #(p.0 - 1, p.1 - 1), p, #(p.0 + 1, p.1 + 1))
      && check_mas(m, #(p.0 + 1, p.1 - 1), p, #(p.0 - 1, p.1 + 1))
    }
    // M S
    //  A
    // M S
    || {
      check_mas(m, #(p.0 - 1, p.1 - 1), p, #(p.0 + 1, p.1 + 1))
      && check_mas(m, #(p.0 - 1, p.1 + 1), p, #(p.0 + 1, p.1 - 1))
    }
    // S S
    //  A
    // M M
    || {
      check_mas(m, #(p.0 - 1, p.1 + 1), p, #(p.0 + 1, p.1 - 1))
      && check_mas(m, #(p.0 + 1, p.1 + 1), p, #(p.0 - 1, p.1 - 1))
    }
    // S M
    //  A
    // S M
    || {
      check_mas(m, #(p.0 + 1, p.1 - 1), p, #(p.0 - 1, p.1 + 1))
      && check_mas(m, #(p.0 + 1, p.1 + 1), p, #(p.0 - 1, p.1 - 1))
    }

  is_match
}

fn check_mas(
  matrix: dict.Dict(Point, String),
  m_point: Point,
  a_point: Point,
  s_point: Point,
) -> Bool {
  let has_m =
    dict.get(matrix, m_point)
    |> result.map(string.contains(_, "M"))
    |> result.unwrap(False)
  let has_a =
    dict.get(matrix, a_point)
    |> result.map(string.contains(_, "A"))
    |> result.unwrap(False)
  let has_s =
    dict.get(matrix, s_point)
    |> result.map(string.contains(_, "S"))
    |> result.unwrap(False)

  has_m && has_a && has_s
}
