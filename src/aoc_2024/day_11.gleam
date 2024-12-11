import carpenter/table
import gleam/int
import gleam/list
import gleam/string
import rememo/memo

pub fn pt_1(input: String) {
  let init_stones = string.split(input, on: " ")

  let blink_cnt = 25
  use cache <- memo.create()

  list.fold(init_stones, 0, fn(stone_cnt, stone) {
    stone_cnt + count(stone, blink_cnt, cache)
  })
}

pub fn pt_2(input: String) {
  let init_stones = string.split(input, on: " ")

  let blink_cnt = 75
  use cache <- memo.create()

  list.fold(init_stones, 0, fn(stone_cnt, stone) {
    stone_cnt + count(stone, blink_cnt, cache)
  })
}

fn count(
  stone: String,
  remaining_blink_cnt: Int,
  cache: table.Set(#(String, Int), Int),
) -> Int {
  use <- memo.memoize(cache, #(stone, remaining_blink_cnt))

  let stone_len = string.length(stone)

  case remaining_blink_cnt {
    0 -> 1
    _ ->
      case stone {
        "0" -> count("1", remaining_blink_cnt - 1, cache)
        s if stone_len % 2 == 0 -> {
          let middle_idx = stone_len / 2
          let assert Ok(left) = string.slice(s, 0, middle_idx) |> int.parse()
          let assert Ok(right) =
            string.slice(s, middle_idx, stone_len - middle_idx) |> int.parse()
          count(int.to_string(left), remaining_blink_cnt - 1, cache)
          + count(int.to_string(right), remaining_blink_cnt - 1, cache)
        }
        s -> {
          let assert Ok(stone_num) = int.parse(s)

          count(int.to_string(stone_num * 2024), remaining_blink_cnt - 1, cache)
        }
      }
  }
}
