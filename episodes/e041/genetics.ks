{
  local genetics is lex(
    "seek", seek@
  ).

  function seek {
    parameter config.
    local chromosomes is list().
    local generation is 1.
    local best_score is 0.
    local scores is lex().
    local best is 0.

    if exists(config["file"]) load_stored_data().
    else create_new_data().

    until 0 {
      evaluate(chromosomes).
      set children to select(chromosomes).
      set children to cross(chromosomes).
      set children to mutate(chromosomes).
      set chromosomes to children.
      set generation to generation + 1.
    }

    function load_stored_data {
      local stored_data is readjson(config["file"]).
      set chromosomes to stored_data["chromosomes"].
      set best_score to stored_data["best_score"].
      set generation to stored_data["generation"].
      set scores to stored_data["scores"].
      set best to stored_data["best"].
    }

    function create_new_data {
      for i in range(0, config["size"]) {
        local chromosome is "".
        for j in range(0, config["arity"] * 32) set chromosome to chromosome + round(random()).
        chromosomes:add(chromosome).
      }
    }

    function evaluate {
      parameter data, c is 0.
      for item in data {
        set c to c + 1.
        if not scores:haskey(item) {
          hudtext("Generation: " + generation, 30, 2, 50, white, false).
          hudtext(c + " / " + config["size"], 30, 2, 50, white, false).
          local args is list().
          for i in range(0, item:length / 32)
            args:add(to_frac(item:substring(32 * i, 32))).
          set scores[item] to config["fitness"](args).
          if scores[item] > best_score {
            set best to args.
            set best_score to scores[item].
          }
          persist_data().
          if config:haskey("autorevert") kuniverse:reverttolaunch().
        }
      }
    }

    function persist_data {
      local data is lex(
        "chromosomes", chromosomes,
        "best_score", best_score,
        "generation", generation,
        "scores", scores,
        "best", best
      ).
      deletepath(config["file"]).
      writejson(data, config["file"]).
    }

    function select {
      parameter data, total is 0, pick is list().
      for item in data set total to total + scores[item].
      if total = 0 return data.
      until pick:length = data:length {
        local item is data[floor(random() * data:length)].
        if random() < scores[item] / total pick:add(item).
      }
      return pick.
    }

    function cross {
      parameter data, pick is list().
      for i in range(0, data:length, 2) {
        local a is data[i]. local b is data[i+1].
        local l is a:length. local c is floor(random() * l).
        pick:add(a:substring(0, c) + b:substring(c, l - c)).
        pick:add(b:substring(0, c) + a:substring(c, l - c)).
      }
      return pick.
    }

    function mutate {
      parameter data, pick is list().
      for item in data {
        for i in range(0, item:length) {
          if random() < 1 / item:length {
            local bit is item:substring(i,1).
            if bit = "1" set bit to "0". else set bit to "1".
            set item to item:insert(i, bit):remove(i + 1, 1).
          }
        }
        pick:add(item).
      }
      return pick.
    }
  }

  function to_frac {
    parameter bits, int is 0.
    for i in range(0, bits:length)
      if bits:substring(bits:length - i - 1, 1) = "1"
        set int to int + 2^i.
    return int / 2^32.
  }

  function to_s {
    parameter int, bits is "".
    until int = 0 {
      set bits to mod(int, 2) + bits.
      set int to floor(int / 2).
    }
    return bits:padleft(32):replace(" ","0").
  }

  export(genetics).
}
