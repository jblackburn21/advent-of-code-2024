import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string

type Point =
  #(Int, Int)

pub fn pt_1(input: String) {
  let #(grid, start_points) =
    string.split(input, on: "\n")
    |> list.index_fold(#(set.new(), set.new()), fn(accum_y, row, y) {
      string.to_graphemes(row)
      |> list.filter_map(int.parse(_))
      |> list.index_fold(accum_y, fn(accum_x, height, x) {
        case height {
          0 -> #(accum_x.0, set.insert(accum_x.1, #(x, y)))
          h -> #(set.insert(accum_x.0, #(#(x, y), h)), accum_x.1)
        }
      })
    })

  set.fold(start_points, 0, fn(accum, p) {
    let paths = get_paths(grid, #(p, 0), set.new())
    accum + set.size(paths)
  })
}

pub fn pt_2(input: String) {
  let #(grid, start_points) =
    string.split(input, on: "\n")
    |> list.index_fold(#(set.new(), set.new()), fn(accum_y, row, y) {
      string.to_graphemes(row)
      |> list.filter_map(int.parse(_))
      |> list.index_fold(accum_y, fn(accum_x, height, x) {
        case height {
          0 -> #(accum_x.0, set.insert(accum_x.1, #(x, y)))
          h -> #(set.insert(accum_x.0, #(#(x, y), h)), accum_x.1)
        }
      })
    })

  set.fold(start_points, 0, fn(accum, p) { accum + get_path_cnt(grid, #(p, 0)) })
}

fn get_paths(
  grid: Set(#(Point, Int)),
  curr: #(Point, Int),
  found_paths: Set(Point),
) -> Set(Point) {
  let curr_point = curr.0
  let curr_height = curr.1

  case curr_height {
    // count full path
    9 -> {
      set.insert(found_paths, curr_point)
    }
    // check next height
    h -> {
      let next_height = h + 1

      let check_points = [
        // up
        #(curr_point.0, curr_point.1 - 1),
        // down
        #(curr_point.0, curr_point.1 + 1),
        // left
        #(curr_point.0 - 1, curr_point.1),
        // right
        #(curr_point.0 + 1, curr_point.1),
      ]

      list.fold(check_points, found_paths, fn(accum, p) {
        let next = #(p, next_height)
        let can_proceed = set.contains(grid, next)

        case can_proceed {
          True -> get_paths(grid, next, accum)
          False -> accum
        }
      })
    }
  }
}

fn get_path_cnt(grid: Set(#(Point, Int)), curr: #(Point, Int)) -> Int {
  let curr_point = curr.0
  let curr_height = curr.1

  case curr_height {
    // count full path
    9 -> 1
    // check next height
    h -> {
      let next_height = h + 1

      let check_points = [
        // up
        #(curr_point.0, curr_point.1 - 1),
        // down
        #(curr_point.0, curr_point.1 + 1),
        // left
        #(curr_point.0 - 1, curr_point.1),
        // right
        #(curr_point.0 + 1, curr_point.1),
      ]

      list.fold(check_points, 0, fn(accum, p) {
        let next = #(p, next_height)
        let can_proceed = set.contains(grid, next)

        case can_proceed {
          True -> accum + get_path_cnt(grid, next)
          False -> accum
        }
      })
    }
  }
}
