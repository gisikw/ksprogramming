// Recoverable Genetic Algorithm Library
// Kevin Gisi
// http://youtube.com/gisikw

// Get the quote character
set l to lexicon(). l:add("0",0).
set q to l:dump:substring(23,1). unset l.
// NOTE: The prior two lines can be replaced with the following in kOS > 0.19.3:
// set q to char(34).

// Recover any stored data
log "" to ga_data.ks. run ga_data.ks.
if not (defined ga_gen) {
  global ga_gen is -1.
  global ga_data is list().
}

// Save data to ga_data.ks.
function ga_save {
  local str is "set ga_gen to "+ga_gen+".".
  set str to str+"set ga_data to list(".
  for item in ga_data {
    set str to str+"list("+q+item[0]+q+","+item[1]+"),".
  }
  set str to str:substring(0,str:length-1)+").".

  log "" to ga_data.ks. delete ga_data.ks.
  log str to ga_data.ks.
}

// Set up a new test with starting chromosomes
function ga_init {
  parameter chroms.
  set ga_gen to 1.
  set ga_data to list().
  for chr in chroms ga_data:add(list(chr,-1)).
  log "" to ga_log.txt. delete ga_log.txt.
  ga_save().
}

// Get the next fitness, or create a new generation
function ga_next {
  if not ga_next_fitness() ga_new_generation().
}

// Get fitness for an unscored chromosome, or return false
function ga_next_fitness {
  for item in ga_data if item[1] = -1 {
    set item[1] to ga_fitness(item[0]).
    ga_save(). return 1.
  }
  return 0.
}

// Create a new generation from the current population
function ga_new_generation {
  log "=== Generation " + ga_gen + " ===" to ga_log.txt.
  log ga_data:dump to ga_log.txt.
  set ga_gen to ga_gen + 1.
  set ga_data to ga_mutate(ga_cross(ga_select(ga_data))).
  ga_save().
}

// Select parents using roulette-wheel selection
function ga_select {
  parameter data. local len is data:length.
  local parents is list(). local total is 0.

  for item in data set total to total + item[1].

  until parents:length = len {
    local item is data[floor(random()*len)].
    if random() < item[1] / total parents:add(item).
  }

  return parents.
}

// Generate children using single-point crossover
function ga_cross {
  parameter data. local len is data:length.
  local children is list().

  from{local i is 0.} until i=len step{set i to i+2.} do{
    local mom is data[i]. local dad is data[i+1].
    local kid1 is list(0,-1). local kid2 is list(0,-1).

    local c is mom[0]:length.
    local s is floor(random() * c).

    children:add(list(mom[0]:substring(0,s)+dad[0]:substring(s,c-s),-1)).
    children:add(list(dad[0]:substring(0,s)+mom[0]:substring(s,c-s),-1)).
  }

  return children.
}

// Mutate children via bit-flipping, at a 1% chance of mutation
function ga_mutate {
  parameter data. local len is data[0][0]:length.
  for item in data {
    from{local i is len-1.} until i=-1 step{set i to i-1.} do {
      if random() < 1 / len {
        local bit is item[0]:substring(i,1).
        if bit = "1" set bit to "0". else set bit to "1".
        set item[0] to item[0]:insert(i,bit):remove(i+1,1).
      }
    }
  }
  return data.
}
