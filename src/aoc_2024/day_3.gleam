import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\(\\d{0,3},\\d{0,3}\\)")
  let matches = regexp.scan(with: re, content: input)

  list.map(matches, fn(m) { m.content })
  |> list.filter_map(parse_mul)
  |> list.map(fn(p) { p.0 * p.1 })
  |> int.sum()
}

pub fn pt_2(input: String) {
  let assert Ok(re) =
    regexp.from_string("(mul\\(\\d{0,3},\\d{0,3}\\)|don't\\(\\)|do\\(\\))")

  let matches = regexp.scan(with: re, content: input)

  list.map(matches, fn(m) { m.content })
  |> sum_list(#(True, 0))
  |> pair.second()
}

fn parse_mul(m: String) -> Result(#(Int, Int), Nil) {
  string.split_once(m, on: ",")
  |> result.map(fn(s) {
    let first = pair.first(s) |> string.drop_start(up_to: 4) |> int.parse()
    let second = pair.second(s) |> string.drop_end(up_to: 1) |> int.parse()

    pair.new(result.unwrap(first, 0), result.unwrap(second, 0))
  })
}

fn sum_list(list: List(String), accum: #(Bool, Int)) -> #(Bool, Int) {
  case list {
    [first, ..rest] ->
      case first {
        "don't()" -> sum_list(rest, pair.new(False, accum.1))
        "do()" -> sum_list(rest, pair.new(True, accum.1))
        _ as m ->
          case accum.0 {
            True ->
              sum_list(
                rest,
                pair.new(
                  accum.0,
                  accum.1
                    + {
                    parse_mul(m)
                    |> result.map(fn(t) { t.0 * t.1 })
                    |> result.unwrap(0)
                  },
                ),
              )
            False -> sum_list(rest, accum)
          }
      }
    [] -> accum
  }
}
