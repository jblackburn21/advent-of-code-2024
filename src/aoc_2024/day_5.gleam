import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import gleam/string
import gleam/yielder

pub fn pt_1(input: String) {
  let assert Ok(split) = string.split_once(input, on: "\n\n")

  let rules =
    string.split(split.0, on: "\n")
    |> list.take_while(fn(r) { r != "" })
    |> list.filter_map(fn(r) {
      string.split_once(r, on: "|")
      |> result.map(fn(s) {
        let l = int.parse(s.0) |> result.unwrap(0)
        let r = int.parse(s.1) |> result.unwrap(0)
        pair.new(l, r)
      })
    })

  let updates =
    string.split(split.1, on: "\n")
    |> list.map(fn(u) {
      string.split(u, on: ",")
      |> list.filter_map(int.parse(_))
    })

  let valid_updates =
    list.filter(updates, fn(u) { check_pages(rules, u) |> pair.first })

  let middle_pages = get_middle_pages(valid_updates)

  int.sum(middle_pages)
}

pub fn pt_2(input: String) {
  let assert Ok(split) = string.split_once(input, on: "\n\n")

  let rules =
    string.split(split.0, on: "\n")
    |> list.take_while(fn(r) { r != "" })
    |> list.filter_map(fn(r) {
      string.split_once(r, on: "|")
      |> result.map(fn(s) {
        let l = int.parse(s.0) |> result.unwrap(0)
        let r = int.parse(s.1) |> result.unwrap(0)
        pair.new(l, r)
      })
    })

  let updates =
    string.split(split.1, on: "\n")
    |> list.map(fn(u) {
      string.split(u, on: ",")
      |> list.filter_map(int.parse(_))
    })

  let sort_pages =
    list.map(updates, fn(u) { check_pages(rules, u) })
    |> list.filter(fn(p) { p.0 == False })
    |> list.map(pair.second(_))

  let middle_pages = get_middle_pages(sort_pages)

  int.sum(middle_pages)
}

fn check_pages(rules: List(#(Int, Int)), pages: List(Int)) -> #(Bool, List(Int)) {
  let sorted = sort_pages(rules, pages)

  let is_sorted = list.zip(pages, sorted) |> list.all(fn(p) { p.0 == p.1 })

  pair.new(is_sorted, sorted)
}

fn sort_pages(rules: List(#(Int, Int)), pages: List(Int)) -> List(Int) {
  list.sort(pages, fn(l, r) {
    case list.contains(rules, pair.new(l, r)) {
      True -> order.Lt
      False -> order.Gt
    }
  })
}

fn get_middle_pages(updates: List(List(Int))) -> List(Int) {
  list.map(updates, fn(u) {
    let yield = yielder.from_list(u)
    int.floor_divide(list.length(u), 2)
    |> result.map(yielder.at(yield, _))
    |> result.flatten()
    |> result.unwrap(0)
  })
}
