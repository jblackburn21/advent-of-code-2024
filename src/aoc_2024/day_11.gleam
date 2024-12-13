import carpenter/table
import gleam/int
import gleam/string
import gleam/yielder
import rememo/memo

pub fn pt_1(input: String) {
  let init_stones = string.split(input, on: " ")

  count_stones(init_stones, 25)
}

pub fn pt_2(input: String) {
  let init_stones = string.split(input, on: " ")

  count_stones(init_stones, 75)
}

fn count_stones(stones: List(String), blink_cnt: Int) -> Int {
  use cache <- memo.create()

  yielder.from_list(stones)
  |> yielder.fold(0, fn(stone_cnt, stone) {
    stone_cnt + count(stone, blink_cnt, cache)
  })
}

fn count(
  stone: String,
  remaining_blink_cnt: Int,
  cache: table.Set(#(String, Int), Int),
) -> Int {
  use <- memo.memoize(cache, #(stone, remaining_blink_cnt))

  case remaining_blink_cnt {
    0 -> 1
    _ -> {
      let stone_len = string.length(stone)

      case stone {
        "0" -> count("1", remaining_blink_cnt - 1, cache)
        s if stone_len % 2 == 0 -> {
          let middle_idx = stone_len / 2
          let left = string.slice(s, 0, middle_idx)
          let assert Ok(right) =
            string.slice(s, middle_idx, stone_len - middle_idx) |> int.parse()
          count(left, remaining_blink_cnt - 1, cache)
          + count(int.to_string(right), remaining_blink_cnt - 1, cache)
        }
        s -> {
          let assert Ok(stone_num) = int.parse(s)

          count(int.to_string(stone_num * 2024), remaining_blink_cnt - 1, cache)
        }
      }
    }
  }
}
