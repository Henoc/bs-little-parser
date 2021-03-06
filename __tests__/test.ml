open Parser
open Jest

let () =
  let open Expect in
  test "parse" (fun () ->
    let input = Input.{text = "abcdefg"; index = 0; whitespace = " "} in
    let abc = stringParser "abc" in
    let result = abc input in
    match ParseResult.getResult result with
    | Some x ->
      expect x |> toEqual "abc" |> ignore;
      expect (ParseResult.getIndex result) |> toBe 3
    | None -> assert false
  );

  test "<*>" (fun () ->
    let input = Input.{text = "abcdefg"; index = 0; whitespace = " "} in
    let abc = stringParser "abc" in
    let def = stringParser "def" in
    let result = (abc <*> def) input in
    match ParseResult.getResult result with
    | Some x ->
      expect x |> toEqual ("abc", "def") |> ignore;
      expect (ParseResult.getIndex result) |> toBe 6
    | None -> assert false
  );

  test "<|>" (fun () ->
    let input = Input.{text = "abcdefg"; index = 0; whitespace = " "} in
    let abc = stringParser "abx" in
    let def = stringParser "abc" in
    let result = (abc <|> def) input in
    match ParseResult.getResult result with
    | Some x ->
      expect x |> toEqual ("abc") |> ignore;
      expect (ParseResult.getIndex result) |> toBe 3
    | None -> assert false
  );

  test "<*, *>" (fun () ->
    let input = Input.{text = "abcdefg"; index = 0; whitespace = " "} in
    let result = ((str "abc") *> (str "def") <* (str "g")) input in
    match ParseResult.getResult result with
    | Some x ->
      expect x |> toEqual ("def") |> ignore;
      expect (ParseResult.getIndex result) |> toBe 7
    | None -> assert false
  );

  test "regex" (fun () ->
    let input = Input.{text = "abcdefg"; index = 0; whitespace = " "} in
    let result = regex (Js.Re.fromString "[abcde]+") input in
    match ParseResult.getResult result with
    | Some x ->
      expect x |> toEqual ("abcde") |> ignore;
      expect (ParseResult.getIndex result) |> toBe 5
    | None -> assert false
  )