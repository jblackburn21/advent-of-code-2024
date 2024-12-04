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
  |> list.map(parse_mul)
  |> list.map(calc_instr)
  |> int.sum()
}

pub fn pt_2(input: String) {
  let assert Ok(re) =
    regexp.from_string("(mul\\(\\d{0,3},\\d{0,3}\\)|don't\\(\\)|do\\(\\))")

  let matches = regexp.scan(with: re, content: input)

  list.map(matches, fn(m) { m.content })
  |> list.fold(from: #(True, 0), with: fn(accum, m) {
    case m {
      "don't()" -> pair.new(False, accum.1)
      "do()" -> pair.new(True, accum.1)
      _ as mul ->
        case accum.0 {
          True ->
            pair.new(accum.0, accum.1 + { parse_mul(mul) |> calc_instr() })
          False -> accum
        }
    }
  })
  |> pair.second()
}

fn parse_mul(m: String) -> #(Int, Int) {
  string.split_once(m, on: ",")
  |> result.map(fn(s) {
    let first = pair.first(s) |> string.drop_start(up_to: 4) |> int.parse()
    let second = pair.second(s) |> string.drop_end(up_to: 1) |> int.parse()

    pair.new(result.unwrap(first, 0), result.unwrap(second, 0))
  })
  |> result.unwrap(#(0, 0))
}

fn calc_instr(mul: #(Int, Int)) {
  mul.0 * mul.1
}
