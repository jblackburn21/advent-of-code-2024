import gleam/int
import gleam/list.{Continue, Stop}
import gleam/pair
import gleam/result
import gleam/string

// 190: 10 19 -> 10+19, 10*19
// 3267: 81 40 27 -> 81+40+27, 81+40*27 -> 81*40*27 -> 81*40+27

pub fn pt_1(input: String) {
  let ops = [int.multiply, int.add]

  let equations =
    string.split(input, on: "\n")
    |> list.map(fn(e) {
      let assert Ok(split) = string.split_once(e, on: ": ")

      let assert Ok(test_val) = int.parse(split.0)

      let nums = string.split(split.1, on: " ") |> list.filter_map(int.parse(_))

      pair.new(test_val, nums)
    })

  list.fold(equations, 0, fn(accum, e) {
    case check_solvable(e.0, e.1, ops) {
      True -> accum + e.0
      False -> accum
    }
  })
}

pub fn pt_2(input: String) {
  let ops = [int.multiply, int.add, concat_nums]

  let equations =
    string.split(input, on: "\n")
    |> list.map(fn(e) {
      let assert Ok(split) = string.split_once(e, on: ": ")

      let assert Ok(test_val) = int.parse(split.0)

      let nums = string.split(split.1, on: " ") |> list.filter_map(int.parse(_))

      pair.new(test_val, nums)
    })

  list.fold(equations, 0, fn(accum, e) {
    case check_solvable(e.0, e.1, ops) {
      True -> accum + e.0
      False -> accum
    }
  })
}

fn concat_nums(a: Int, b: Int) -> Int {
  string.concat([int.to_string(a), int.to_string(b)])
  |> int.parse()
  |> result.unwrap(0)
}

fn check_solvable(
  test_val: Int,
  nums: List(Int),
  ops: List(fn(Int, Int) -> Int),
) -> Bool {
  case nums {
    [a] -> a == test_val
    [a, b, ..rest] ->
      list.fold_until(ops, False, fn(accum, op) {
        case check_solvable(test_val, [op(a, b), ..rest], ops) {
          False -> Continue(accum)
          True -> Stop(True)
        }
      })
    [] -> False
  }
}
