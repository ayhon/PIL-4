# Chapter 1 - Getting started
chunks     → piece of code
 * Interactive mode: Execute code line by line
 * Executing files: Execute whole **chunks** of code

```lua
function love.update()
    x = "Hello world"
    return x
end
```

Use `lua -i file` to let Lua know we want to enter 
interactive mode after running a file. Useful for 
debugging  
We can also use the function `dofile("file.lua")` 
to run chunks of Lua code from a file

Use `lua -e "code"` to run some code in the interpreter

Use `lua -l lib` to load a library `lib`

The interpreter always outputs the values of expressions.
To prevent this output from an expresion, you can append a 
`;` to it
```lua
> math.floor(3.14) --> Out: 3
> math.floor(3.14) --> Nothing
```

When a script is called with arguments, you can access them
through the global table `args`
```lua
$ lua -e "sin=math.sin" script a b --[[
    a[-3]    "lua"
    a[-2]    "-e"
    a[-1]    "sin=math.sin"
    a[0]    "script"
    a[1]    "a"
    a[2]    "b"
]]
```
You usually only need the positive indexes.

## Comments
With `--` as `//`  
With `--[[` and `]]` as `/*` and `*/`

#### Common trick with comments
```lua
--[[
code here
--]]
```
Now add one more `-`

```lua
---[[
code here
--]]
```
and we uncomment a whole section at once

## Variables
Global variables don't need a declaration, just use
them. Return `nil` if not initialized.

### Types
There are 8, though Lua is dinamically typed:

 1. nil (empty, like `null` in Java, but more general)
 2. boolean (false is `false` and `nil`, else true)
 3. number
 4. string
 5. userdata
 6. function
 7. threads
 8. tables

The function `type()` returns an objects type's name
as a string

# Chapter 2 - Interlude: The Eight-Queen puzzle
```lua
N = 8 -- board size

-- Is (n,c) safe from attacks?
function isplaceok(a, n, c)
    for i = 1, n-1 do
        if (a[i] == c) or
           (a[i]-i == c-n) or
           (a[i]+i == c+n) then
            return false
        end
    end
    return true
end

-- Print state of board a
function printSolution (a)
    for i = 1, N do
        for j = 1, N do
            io.write( a[i] == j and "X" or "-", " " )
        end
        io.write('\n')
    end
    io.write('\n')
end

-- Add to board a all the queens from n to N
function addqueen (a,n)
    if n > N then
        printSolution(a)
    else
        for c = 1, N do
            if isplaceok(a,n,c) then
                a[n] = c
                addqueen(a, n+1)
            end
        end
    end
end
```
# Chapter 3 - Numbers
In Lua 5.3, we have both integers and doubles. Both are identified as 
`"number"` by `type()`, if more precission is needed, you can use
```lua
math.type(number)
```

Hexadecimal with `0x`, you can also have fractional part in this format. 
Exponents after `p` (With decimals, use `e`, as in scientific notation)

Operators are as usual, but `//`, the integer division, can return doubles
if any of its operands are doubles (Although the return value will have an 
integer value
```lua
> 3.0 // 2 -->  1.0
```

Also, the modulo operator for integers is defined by the equation
```lua
a % b = a - ((a//b) * b)
```
Therefore, `a%b` is always positive

For doubles, the module operator is used to indicate precission
```lua
> math.pi%0.01   --> 3.14
> math.pi%0.001  --> 3.141
```

##### `math` library
Cool functions you expected to be
* `math.huge` returns `inf`
* `math.max(a,b,c,d)`  
* `math.sin(a)`

Generating random values
* `math.random()` return real in $[0,1)$
* `math.random(n)` returns integer in $[1,n]$
* `math.random(l,u)` returns integer in $[l,u]$

Rounding
* `math.floor(d)` returns lowest
* `math.ceil(d)` returns highest
* `math.fmod(d)` returns closes to 0 (And as a second value, the difference / fractional part)

Limits
* `math.maxinteger`
* `math.mininteger`

##### Conversions
###### `integer` → `double`
Just add `0.0`
```lua
> -3 + 0.0 --> -3.0
```

###### `double` → `integer`
Do a biwise or with 0
```lua
> 2^53 | 0 --> 9007199254740992
```
only works if there is no loss of information, if not, an error
is raised.

We can also use `math.tointeger(d)`. If integer can't be 
represented, `nil` is returned

# Chapter 4 - Strings
In Lua, strings are sequences of bytes → Any piece of 
binary data can be saved as a string

Get the length with `#`

Concatenate with `..`

Use either `"` or `'`, doesn't matter

###### Spcecial Character sequences
* `\a` Bell
* `\b` Backspace
* `\f` Form feed
* `\n` New line
* `\r` Carriage return (MacOS stuff)
* `\t` Horizontal tab
* `\v` Vertical tab
* `\\` Escaping
* `\"` Escaping
* `\'` Escaping  
* `\z` Ignore following `\n` (Useful in multiline strings)  
Also, `\ddd` or `\xhh` specify characters by code, where
`ddd` are decimal values and`hh` are hexadecimal ones  
You can as well use `\u{h... h}` to write UTF-8 characters
by code

Declare long strings by using `[[` to start and `]]` to end.
In case that there may be conflicts with the data inside the 
string and the ending sequence (There is a `]]` somewhere), 
we can use any number of `=` signs in between the `[` so it 
will only close when two `]` with the same number of `=` signs
in between appear in the data.

This is how multiline comments work, commenting a multiline 
string

###### `string` to `number`
Use `tonumber("num")`, returns `nil` if not valid

`tonumber("num", base)` can accept a `base` argument, between
2 to 36, for conversion (Uses the alphabet until Z)

##### The `string` library
It has some pretty powerful stuff
* `string.rep(string, times)`
* `string.reverse(string)`
* `string.lower(string)`
* `string.upper(string)`
* `string.sub(string, ini, fin)`  
Returns substring in $[$`ini`$,$`fin`$]$. Indexes can be negative,
count from the end like Python
* `string.char(num1, ... numN)`  
Converts from `integer` to `char` the values given, and concatenates
them into a string
* `string.byte(string, idx1, ..., idxN)`  
Converts from `char` to `integer`. idx1 is 1 by default
* `string.format(string, var1, ..., varN)`
* `string.find(string, pattern)`  
Returns (ini, fin) of pattern, or `nil` if not found
* `string.gsub(string, search, replace)`  
Performs all possible substitutions. Also returns the number of them after the modified string  
`replace` can also be a function 

#### The `utf8` library
Because 1 char $\not\rightarrow $ 1 byte, we have to take measures
* `utf8.len(string)`
* `utf8.char(num1, ... numN)` (See `string.char`)
* `utf8.codepoint(string, idx1, ..., idx)` (See `string.byte`)
* `utf8.offset(string, idx)`  
Converts a character position to its UTF-8 byte position
* `utf8.codes(string)`  
Allows you to iterate over characters in UTF-8 strings  
    ```lua
    for i, c in utf8.codes("Açâo") do
        print(i,c)
    end
    ```

# Chapter 5 - Tables
These are objects (Are passed by reference). If there are no more
references to the data table, the Garbage Collector removes the data

Access elements with `t.x` or `t[k]`. `t.x` is equivalent to `t["x"]`

Tables are constructed with `{` and `}`
* `{}` is an empty table
* `{item1, item2, ..., itemN}` is a table with `t[1]` = `item1`, 
etc...
* `{key1=val1, ...}` is a table with suck key-value pairs, where keys
are strings
* `{[expr]=val1,...}` lets us use any expression as a key

Use the `#` operator to retrieve the length of a sequence of a table,
where a sequence is an uninterrupted succession of values indexed
from 1 to n.

This is kind of finicky. Sometimes it may be better to store the
length of a structure separately

### List traversal
```lua
for key, value in pairs(datatable) do
    -- Code here
end
```
```lua
for key, value in ipairs(list) do
    -- Code here
end
```
Prefer `ipairs` over `pairs` with sequences. `pairs` does not ensure
any type of order
 
### Safe navigation
If you want to access a value inside of a table nested in more tables, we need to have a mechanism that ensures that such tables exists

The following code could error if any of the intermediary tables
does not exist, or if its names were misspelled
```lua
> zip = company.director.address.zipcode
```
To ensure we access the value safely with the minimum number of 
table queries, we can write it as such
```lua
> zip = (((company or {}).director or {}).address or {}).zipcode
```
This is simiar to other languages features such as the `?` operator
in C#, where the same is achieved as
```c#
> zip = company?.director?.address?.zipcode
```

### The `table` library
* `table.insert(table, [idx,] elem)`   
Inserts `elem` in table at the
end (Or `idx` if specified)
* `table.remove(table[, idx])`  
Returns and removes the last element (Or at `idx` if given)
* `table.move(table, ini, end, idx[, otherTable])`  
Moves elements from `ini` to `end` to position `idx` in the same
table (Or `otherTable` if specified)

# Chapter 6 - Functions
If function takes one parameter and it's a literal string or table constructor, no parenthesis are needed

Also, `o:foo()` translates to `o.foo(o)`

Syntax:
```lua
function name(args)
    -- code here
    return val1, val2 -- optional
end
```

If a parameter isn't provided, `nil` is asigned. If any extra parameters are asigned, they are discarded.

Functions can return multiple values **if they are the last element (or only) of an expresion list**, using the `,` list syntax.
```lua
function foo() return 1, 2, 3 end
> x, y = foo()      -- x = 1, y = 2
> x, y = foo(), 1 -- x = 1, y = 1
```
The `,` lists only appear in:
 * Multiple assignments
     ```lua
     i,e = string.find("hello", "ll")
     ```
 * Arguments to function calls
     ```lua
     string.char(1, 2, 3, 4)
     ```
 * Table constructors
     ```lua
     t = {1, 2, 3, 4}
     ```
 * `return` statements
     ```lua
     return 1, 2, 3, 4
     ```
You can make functions take an arbitrary number of arguments. 
**Extra** arguments are represented with `...`
```lua
function fwrite (fmt, ...)
    return io.write(string.format(fmt, ...))
end
```
```lua
function (a,b,c)
    --- Code here
end
-- EQUIVALENT
function (...)
    local a, b, c = ...
    --- Code here
end
```
Use `{...}` to treat arguments as if they were a table. You can also
use `table.pack(...)` for that purpose, and it will also generate a
key `n` with the number of arguments  
*This can be useful when there may be trailing `nil`s, but you want
the number of arguments provided explicitely to still be recorded*

`select(n, ...)` returns the elements from n to the end of the 
"sequence", if n is a number, or if `n="#"`, the number of elements
of the "sequence" is provided.

`table.unpack(list)` takes all the values from a list and returns 
them. Equivalent to `...obj` in JavaScript.
It also accepts extra parameters. `table.unpack(list, ini, fin)`,
where it only includes the elements in $[$`ini`$,$`fin`$]$
in the return call (By default, returns all)

### Proper tail calls
Lua has tail-call elimination. This means that, if we are in the 
following situation
```lua
function f (x)
    x = x + 1
    retur g(x)
end
```
Lua recognizes that `f` doesn't have to wait for `g` to return, and
liberates such space from the stack, making functions such as 
```lua
function f (n)
    if n > 0 then return f(n-1) end
end
```
never overflow the stack.

Tail-call elimination only happens if the function itself ends with a
return statement of the syntax:  
_`return function(args)`_

#### Exercises?

# Chapter 7 - The external world
## Simple IO model
Choose where to read from with `io.input`, where to write to with `io.outpt`  
For example
```lua
> io.output("data.txt")
```

Write data with `io.write()`. This is recomended over `print`, it gives you more control. Also, 
avoid concatenation, splitting into multiple arguments is shorter and faster to execute.

`io.read(op)` is used to read. `op` is a string which decides what and how to read:
* `"a"` reads the whole file, `""` if it's empty
* `"l"` reads the next line (dropping the newline), `nil` if there isn't
* `"L"` reads the next line (keeping the newline), `nil` if there isn't
* `"n"` reads a number, `nil` if there isn't
* _`number`_ reads `number` characters as a string, `nil` if there isn't any more characters  
`io.read(0)` can serve as a `EOF` check. `nil` if `EOF`, `""` if not (which is _truthy_)

## Complete IO model
To open a file, we use `io.open(filename, mode)` where `mode` can be:
* `r` for read
* `w` for write (Overwrites)
* `a``for append
* `b` for binary files

`io.open` returns a stream if successful, `nil` if not.  
An useful idiom communly used when working with files is:
```lua
local f = assert(io.open(filnae, mode))
```

After this, we use the `write` and `read` functions as methods, which means we use the `:` 
operator
```lua
f:write( f:read("l") )
f:close()
```
Don't forget to close a stream when you don't need it anymore

We can also use the predefined streams of `stderr`, `stdin` and `stdout`. 
```lua
io.stderr:write(message)
```

`io.read()` with no arguments returns the current stream
```lua
local temp = io.input()
io.input(handle)
-- Code here
io.input():close()
io.input(temp)
```
 
We can also use `io.lines` to read from a stream. This gives an iterator that continuously 
reads from a stream until the end of file. `lines` can also be used as a method, and accepts 
arguments like `read` does. 

The following code copies the current input to the current output over blocks of 8 KB
```lua
for bloc in io.input():lines(2^13) do -- 2^13 = 8 KB
    io.write(block)
end
```

### Other operations

* `io.tmpfile()` creates a temporary file that is removed when the program ends

* `io.flush()` executes all pending writes to a file. It can also be called as a method

* `handle:setvbuf(op)` is a method that sets the buffering mode of the stream  
`"no"` means no buffering  
`"full"` written when the buffer is full. Accepts second option with buffer size  
`"line"` buffered until a newline. Accepts second option with buffer size

* `handle:seek(whence, offset)` gets and sets the current position of a stream in a file  
`"set"` for offsets relative to the beginning of a file  
`"cur"` for offsets relative to the current position  
`"end"` for offsets relative to the end of a file  
Always returns the 0 position (`"set"` → 1, `"cur"` → position, `"end"` → file-size)

* `os.rename(old, new)` renames a file
* `os.remove(file)` removes a file

### Other system calls
* `os.exit(code, liberateMemory)` exits the program (Default code is `0` or `true` for "no problems")
* `os.getenv(varName)` returns the value of an environment variable (Or `nil` if not found)

### Executing system commands
* `os.execute(command)"` executes the given command. Returns 3 values:   
   * A boolean that says whether the program exited with any errors
   * A string (`"exit"` if exited normally, `"signal"` if interrupted by a signal)
   * A return status (if `"exit"`) or the number of the signal that terminated the program
* `os.popen(command, mode)` executes a command and also connects the output (or input) to a new 
stream and returns it. `mode` decides whether it's input (`"r"`) or output (`"w"`).

These are highly dependant on Operating System, for something more multi-platform, other libraries like *LuaFileSystem* or *luaposix* are recommended.

# Chapter 8 - Filling some gaps
By default, variables are global. Make local with `local`. In interactive mode, as every line is a 
chunk, local variables are destroyed the moment they are run

If you need more granular control over blocks of code, the `do` block represents a different scope
```lua
do
    local a2 = 2 * a
    local d = (b^2 - 4+a*c)^1/2
    x1 = (-b + 2)/a2
    x2 = (-b - 2)/a2
end
print(x1, x2)
```


Idiom to make a global variable behave as a local for a piece of code  
```lua
local foo = foo
```

In a loop, the scope of a local variable declared in a loop includes the condition
```lua
repeat
    sqr = (sqr + x/sqr)/2
    local error = math.abs(sqr^2 - x)
until error < x/1e3
```

### `goto`
Use `goto label` to go to that part of code. labels in code must follow the syntax `::name::`. 
`goto`s are powerful tools that can easily make your code hard to read. You can't jump out of
a function. You can't jump into the scope of a local variable (A point where a local variable 
wasn't initialized but is used)

It's useful when you want to replicate some features not present in Lua like:

 * continue
 * multi-level break
 * multi-level continue
 * redo
 * local error handling
 
For example:
```lua
while some_condition do
    ::redo::
    if some_other_condition then
        goto continue
    else
        if yet_another_condition then
            goto redo    
        end
        -- Code here
    end
    ::continue::
end
```

More than this is not advisable

### Example: Maze game
```lua
goto room1 -- initial room

::room1:: do
    local move = io.read()
    if move == "south" then goto room3
    elseif move == "east" then goto room2
    else
        print("invalid move")
        goto room1 -- stay in the same room
    end
end

::room2:: do
    local move = io.read()
    if move == "south" then goto room4
    elseif move == "west" then goto room1
    else
        print("invalid move")
        goto room2 -- stay in the same room
    end
end

::room3:: do
    local move = io.read()
    if move == "north" then goto room1
    elseif move == "east" then goto room4
    else
        print("invalid move")
        goto room3 -- stay in the same room
    end
end

::room4:: do
    print("Congratulations, you won")
end
```

This is horrible code design, but works.

---
 
# Chapter 9 - Closures

In Lua, functions are first-class values. 
```lua
a = {p = print} 
a.p("Hello world")  --> print("Hello world")

print = math.sin
a.p(print(1))       --> print(math.sin(1))

math.sin = a.p
math.sin(10, 20)    --> print(10, 20)
```

Actually, these two are equivalent:
```lua
funtion foo(x) then
    return 2*x
end
```
```lua
foo = funtion(x) then
    return 2*x
end
```
We call `function(args) body end` the function constructor


Anonymous functions are used in `table.sort(table, orderFunction)`. Functions that handle functions as
arguments or return types are called high-order functions.

```lua
function derivative(f, eps)
    eps = eps or 1e-4
    return function(x) 
        return (f(x + eps) - f(x)) / eps
    end
end
```

A local function can have the syntactic sugar:
```lua
local function f (params)
    -- Code here
end
```
This expands to
```lua
local f;
f = function (params)
    -- Code here
end
```

The declaration of the variable is done before initialization to prevent problems with recursive 
functions.

**Upvalues** or **non-local variables** are variables used inside a function constructor but defined 
elsewhere

A closure is a function and all the code it needs to access non-local variables correctly
```lua
function newCounter()
    local counter = 0 -- Part of the closure of the returned fucntion
    return function ()
        counter = counter + 1
        return counter
    end
end
```
Technically, __closures__ are what's a value in Lua, not functions. Functions are just a prototype
for closures, but theirs terms are often used this way.

This can be useful when redefining standard functions 
```lua
do -- So oldSin is not visible elsewhere
    local oldSin = math.sin
    local k = math.pi / 180
    math.sin = function (x)
        return oldSin(x * k
    end
end
```

We can use the same technique to create secure environments (sandboxes)
```lua
do
    local oldOpen = io.open
    local acces_ok = function (filename, mode)
        -- Check access here
    end

    io.open = function (filename, mode)
        if access_ok(filename, mode) then
            return oldOpen(filename, mode)
        else
            return nil, "access denied"
        end
    end
end
```

## A taste of functional programming
We are going to implement a simple system for geometric regions, where a region is a set of points.

We represent these regions by their characteristic functions (Instead of perhaps objects)

This for example represents a disk with center (1,3) and radius 4.5
```lua
function disk1(x, y)
    return (x-1.0)^2 + (y-3.0)^2 <= 4.5^2
end
```

We can now define a disk factory
```lua
function disk(cx, cy, r)
    return function(x,y)
        return (x-cx)^2 + (y-cy)^2 <= r^2
    end
end
```

Or an axis-aligned rectangle factory
```lua
function rect(left, right, bottom, up)
    return function(x,y)
        return left <= x and x <= rigth and
            bottom <= y and y <= up
    end
end
```

We can now define functions to modify and combine regions
```lua
function complement(r)
    return function(x,y)
        return not r(x,y)
    end
end

function union(r1,r2)
    return function(x,y)
        return r1(x,y) or r2(x,y)
    end
end

function intersection(r1,r2)
    return function(x,y)
        return r1(x,y) and r2(x,y)
    end
end

function difference(r1,r2)
    return function(x,y)
        return r1(x,y) and not r2(x,y)
    end
end


function translate(r,dx, dy)
    return function(x,y)
        return r(x-dx,y-dy) 
    end
end
```

To visualize a region, we can just test each pixel with the figures characteristic function.
For example, a PBM file is a file where after a "P1\nW\nH" header, you can set the matrix of "on" or "off"
pixels to be displayed. It's horribly inefficient, but pretty simple. This function would output
a region in space as a PBM file

```lua
function plot(r, H, W)
    io.write("P1\n",H,"\n",W,"\n")      -- header
    for i = 1, W do
        local y = (W - i*2)/W
        for j = 1, M do
            local x = (j*2 - H)/H
            io.write(r(x,y) and "1" or "0")
        end
        io.write("\n")
    end
end
```
And the following would plot a crescent moon

```lua
c = disk(0,0,1)
plot(difference(c1, translate(c1,0.3,0)), 500, 500)
```

# Chapter 10 - Pattern matching
## Pattern-matching functions
### `string.find`
Syntax: `string.find(string, pattern[, from, doSimple])`  
**Returns** the indexes of the substring that matched or `nil` if not found

`from` is the index from where to start the search

`doSimple` means that the literal string of `pattern` is searched in `string`

### `string.gsub`
Syntax: `string.gsub(string, pattern, replace[, num])`  
**Returns** a version of `string` where every substring that matches `pattern` is substituted by `replace`

`num` is the number of times to make the substitution

`replace` can also be a function that takes the capture groups _(Read ahead)_ and returns the replacement
`replace` can also be a table which if the first capture group is a key of, it's value is the replacement.
If it not, no replacement is done, instead of substituting for `nil`

### `string.match`
Syntax: `string.match(string, pattern)`  
**Returns** the substring that matched in `string`, or `nil` if not found

### `string.gmatch`
Syntax: `string.gmatch(string, pattern)`  
**Returns** an iterable over the substrings that matched `pattern` in `string`

## Patterns
Patterns in Lua use `%` as an scape (Because strings and patterns are the same thing in Lua, so using
the usual `\` can be cumbersome)  
Usually, `%a` where `a` is alphanumeric has an special meaning, and `%.` where `.` is a non-alphanumeric
character just represents itself

 * `.` - All characters
 * `%a` - Letters
 * `%c` - Control characters
 * `%d` - Digits
 * `%g` - Printable characters (Except spaces)
 * `%l` - Lower-case letters
 * `%u` - Upper-case letters
 * `%p` - Punctuation characters
 * `%s` - Space characters
 * `%w` - Alphanumeric characters
 * `%x` - Hexadecimal digits

An uppercase version of any of the above represents the opposite

There are also _magic characters_:  
`(`, `)`, `.`, `%`, `+`, `-`, `*`, `?`, `[`, `]`, `^` and `$`

A _char-set_ is an user-defined character class. All the characters that you want to be matched with need
to be put inside `[]`. A `^` at the beginning of a _char-set_ represents the opposite of the char-set 
without it, and you can define ranges with `-`.

 * `%d` → `[0-9]`  
 * `%x` → `[0-9a-fA-F]`  
 * `%a` → `[A-Za-z]`

We can make these useful with modifiers for repetitions and optional parts

 * `+` -  1 or more repetitions
 * `*` -  0 or more repetitions
 * `-` -  0 or more **lazy** repetitions
 * `?` -  optional (0 or 1 occurrence)

Modifiers to locate matches
 * `^` - represents beginning of the subject string
 * `$` - represents end of the subject string
 * `%bxy` - matches balanced strings (Sequences that start with `x` and end with `y`)   
 Usually useful as `%b()` or the sort
 * `%f[char-set]` - Represents a change form not matching `charset` to matching it. Always matches an
 empty string  
  `%f[%w]the%f[%W]` would match a `the` which is a word by itself, not inside another  
  `%f[%w]` represents a change from `%W` (Not alphanumeric) to `%w` (alphanumeric)  
  `%f[%W]` is the opposite, from alphanumeric to not alphanumeric   
  Treats as if the string starts and ends in the null character (ASCII code 0)

We can yank parts of a matched string with the capture mechanism. We specify captures with `()`.
When a pattern has captures, `string.match` returns each captured value as a separate result. In cases
where the first group match is used in other matches, you can specify such group with `%N` where N is 
a number. `%0` represents the whole match

```lua
s = [[then he said: "it's all right"!]]
quoteChar, quoted Part = string.match(s, "([\"'])(.-)%1")
```
This ensures that once the first group is matched `[\"']`, it uses the 
substring it matched with (In our case, `"`) to complete the pattern.

This can also be used in `string.gsub` to compose the `replace` argument

An useful idiom to trim a string that uses this fact is the following
```lua
function trim(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end
```

## Replacements
We saw that `string.gusb` can take both functions and tables as a replacement. 
A useful example with these
```lua
function expand(s)
    return string.gsub(s, "$(%w*)", _G)
end
```
This will replace any occurrence of `$varname` with the value of `varname` if
that is a global variable.

```lua
function latex2xml(s)
    returns string.gsub(s, "\\(%a)\(%b{})}", function (tag, body)
        body = string.sub(body, 2, -2)         -- get rid of { }
        body = latex2xml(body)                    -- handle nested commands
        return string.format("<%s> %s </%s>", tag, body, tag)
    end
end
```

An emtpy capture (`()`) captures its position in the subject
string. This is, the position of the character at its right.
A good example of its use is in tab expansion
```lua
function expandTabs(s)
    tab = tab or 8
    local corr = 0
    s = string.gsub(s, "()\t", function (p)
        local sp = tab - (p - 1 + corr)%tab
        corr = corr - 1 + sp
        returns string.rep(" ", sp)
    end)
end
```

Make your patterns as specific as possible for speed, avoid empty 
patterns (Patterns that match an empty string)

## Chapter 11 - Interlude: Most frequent words

```lua
local counter = {}

for line in io.lines() do
    for word in string.gmatch(line, "%w+") do
        counter[word] = (counter[word] or 0) + 1
    end
end

local word = {}

for w in pairs(counter) do
    words[#words+1] = w
end

table.sort(words, function (w1, w2)
    return counter[w1] > counter[w2] or
           counter[w1] == counter[w2] and w1 < w2
end)

local n = math.min(tonumber(arg[1]) or math.huge, #words)

for i = 1, n do
    io.write(words[i], "\t", counter[words[i]], "\n")
end
```

# Chapter 12 - Data and time
There are 2 ways: 
 * As an integer that marks the number of seconds that have 
 passed since 1970
 * As a table with the fields  
   * `year` (int)
   * `month` (int)
   * `day` (int)
   * `yday` (int)
   * `wday` (int)
   * `hour` (int)
   * `min` (int)
   * `sec` (int)
   * `isdst` (boolean)  

`os.time()` returns the current date coded as a single number.

`os.time({year=..., ..})` returns the single number that represents 
the table provided.  At least `year`, `month` and `day` fields must be 
provided

`os.date()` is the reverse of `os.time()`.
`os.date(op[, time_in_number])` is the full syntax. 

If `op` is `"*t"`, `os.date()` returns a table. If `time_in_number` 
isn't provided, `os.time()` is used

If `op` is anything else, returns a string with the format specified 
in `op`, where certain keywords may represent different data. If again
`time_in_number` isn't provided, `os.time()` is used. Those special
keywords are (some of them):
 * `%a` abbreviated weekday name
 * `%A` full weekday name
 * `%b` abbreviated month name
 * `%B` full month name
 * `%c` data and time
 * `%d` data of the month
 * `%H` hour, using 24 hour clock
 * `%I` hour, using 12 hour clock
 * `%j` day of the year
 * `%m` month
 * `%M` minute
 * `%p` either "am" or "pm"
 * `%S` second
 * `%w` weekday
 * `%W` week of the year
 * `%x` date
 * `%X` time
 * `%y` two-digit year
 * `%Y` full year
 * `%z` timezone
 * `%%` %

When `op` starts with a `!`, `os.date()` interprets the time as **UTC**

To compute differences of dates in seconds, use `os.difftime(t1,t2)` 

For measuring length of execution time of programs or the sort, it's 
better to use `os.clock()`, which returns the number of seconds of 
CPU time used by the program. This is more precise (float) than 
`os.time()` (int)

# Chapter 13 - Bits and bytes
Since Lua 5.3, new bitwise operator have been added. These are `&`,
`|`, `~` (exclusive or), `>>`, `<<`, and the unary `~`

## Unsigned integers
Not officially supported. Just ignore the sign bit.

Use `%u` option in `string.format` to see an integer as unsigned. 
`%x` to see its hexadecimal representation

To compare, use `math.ult`, math unsigned less than.

## Packing and unpacking binary data
Use `string.pack()` to pack data onto a string, and 
`string.unpack()` to unpack it

`string.pack(format, data...)` packs `data...` as specified by 
`format`

`string.unpack(format, str)` unpacks the data from `str` according
to `format`. It also returns the length of the string + 1 as the 
last value

The format specifies the integer size:
 * `b` for char
 * `h` for short
 * `i` for int
 * `l` for long
 * `j` uses the size of a Lua integer

If any of the above is uppercase, represents an unsigned version 
of themselves

For custom number of `N` bytes, use `iN`

When unpacking, values must fit in Lua integers.

Unsigned integers have the extra option `t` for `size_t`

We can pack strings in 3 representations:
 1. Zero-terminated strings (Uses `z`)
 2. Fixed-length strings (Uses `cn`, where `n` is length)
 3. Strings with explicit length (Uses `sn`, where `n` is length)

We can pack floats using:
 * `f` for single precision
 * `d` for double precision
 * `n` for Lua float

A `>` turns subsequent encodings to a big endian format.  
A `<` turns subsequent encodings to a little endian format.
A `=` turns subsequent encodings to a machines default endianess

The `!n` option forces `string.pack` to align to multiples of n.
Using just `!` uses the machine's default.  
The alignment is done by adding extra zeroes.

The `x` option means one byte of padding: `string.pack` adds a 
zero byte, `string.unpack` skips one byte from the subject string

## Binary files
To get a binary file from `io.open`, use the `"b"` flag, besides
any other flag that's needed.

When we read data from such a file, we typically use 
`"a"` or `"n"` to read `n` bytes

_stdin_ and _stdout_ can only read in _text mode_, so you can't
use them to read binary files

## Examples
Convert from Windows newlines to POSIX newlines
```lua
local inp = assert(io.open(arg[1], "rb"))
local out = assert(io.open(arg[2], "wb"))

local dat = inp:read("a")
data = string.gsub(data, "\r\n", "\n")
out:write(data)

assert(out:close()))
```

Prints all strings found in a binary file
```lua
local f = assert(io.open(arg[1], "rb"))
local data = f:read("a")
local validchars = "[%g%s]"
local pattern = "("..string.rep(validchars,6).."+)\0"
for w in string.gmatch(data, pattern) do
    print(w)
end
```

Create a hexdump
```lua
local f = assert(io.open(arg[1], "rb"))
local blocksize = 16
for bytes in f:lines(blocksize) do
    for i = 1, #bytes do
        local b = stirng.unpack("B", bytes, i)
        io.write(string.format("%02X ", b))
    end
    io.write(stirng.rep("   ", blocksize - #bytes)
    bytes = string.gsub(bytes, "%c", ".")
    io.write(" ", bytes, "\n")
end
```

# Chapter 14 - Data structures
Tables are **the** data structure of Lua

## Arrays
Tables can work as a dynamic array

In Lua, arrays start a 0

## Matrices & multi-dimensional arrays
Use a table of tables or composing various indexes into a single one.    
Tables must be explicitly initialized

Composing indexes is more useful when you are using sparse 
boolean matrices. Use `pairs` to traverse the 

Multiplying sparse matrices
```lua
function mult(a,b)
    local c = {} -- Return value
    for i = 1, #a do
        local resultline = {} -- c[i]
        for k, va in pairs(a[i]) do
            for j, vb in pairs(b[k]) do
                local res = (resultline or 0) + va * vb
                resultline[j] = (res ~= 0) and res or nil
            end
        end
        c[i] = resultline
    end
    return c
end
```
## Linked lists
Each node is represented by a table

```lua
node = {
    next = node,
    value = val
}
```
We can also represent other data structures this way, though it 
usually isn't necessary

## Queues and deques
We can implement them with the help of `table.insert` and `table.remove`. 
As usually a queue doesn't have that many elements, so indexing by an 
ever-increasing integer is mostly whats more efficient

```lua
function listNew()
    return {first = 0, last = -1}
end

function pushFirst(list, value)
    list.first = list.first - 1
    list[list.first] = value
end

function pushLast(list, value)
    list.last = list.last + 1
    list[list.last] = value
end

function popFirst(list)
    if list.first > list.last then
        error("list is empty")
    end
    local value = list[list.first]
    list[list.first] = nil -- allow garbage collection
    list.first = list.first + 1
    return value
end

function popLast(list)
    if list.first > list.last then
        error("list is empty")
    end
    local value = list[list.last]
    list[list.last] = nil
    list.last = list.last - 1
    return value
end
```
 
## Reverse tables
We seldom do searches in Lua. We normally index those 
things we want to search in a table with the info we
need in them

## Sets and bags
For sets, just use a table where the indexes are the
elements, and they all have true values
 
For bags (Or multisets), we do the same thing as with
sets, but we assign them a counter instead of true. 
We delete the keys that end up having an occurrence 
of zero (So it still returns a false value if latter
called)

## String buffers
Concatenation can be expensive. More so if we are 
copying enormous amounts of data over and over, 
like strings in a concatenation. For this, we have
the string buffers.

We achieve the same behaviour in Lua using the 
`table.concat` method, which returns the concatenation
of all strings in a table

`table.concat(table[, separator)` is the full syntax, 
it accepts a delimiter to use between data.

## Graphs
There are many implementations, although they are all
pretty straightforward

**DFS**
```lua
function findpath(curr, to, path, visited)
    path = path or {}
    visited = visited or {}

    if visited[curr] then
        return nil
    end

    visited[curr] = true
    path[#path + 1] = curr

    if curr == to then
        return path
    end

    for node in pairs(curr.adj) do
        local p = findpath(node, to, path, visited)
        if p then return p end
    end
    table.remove(path)
end
```

# Chapter 15 - Data files and serialization

## Data files
If we create the data files, doing so as a .lua 
program makes reading them after that easier.
For example, instead of having this CSV

```csv
Donald E. Knuth, Literate Programming, CSLI,1992
Jon Bentley, More Programming Pearls, Addison-Wesley,1990
```

We could write or data as a .lua file like this

```lua
Entry{"Donald E. Knuth",
      "Literate Programming",
      "CSLI",
      1992}

Entry{"Jon Bentley",
      "More Programming Pearls",
      "Addisoin-Wesley",
      1990}
```

Were each `Entry{}` is a call to the function
`Entry` in with a table as its only argument.

## Serialization

Generally use `tostring`. With numbers it's 
proper to distinguish between `integer` and
`float`. Also, write floats in hexadecimal
form to avoid precission errors (`"%a"`).
This distinction is done automatically by
`"%q"`

When writting a string, to avoid code 
injection use the format `"%q"`, for quoted.

To save tables, implement a recursive 
algorithm to circumvent nested tables.
Note that the keys should be surrounded by
`[%s]` to ensure the key is a valid 
identifier.  This doesn't prevent against 
cycles though

To prevent cycles, we could do something 
like:

```lua
function save(name, value, saved)
    saved = saved or {}
    io.write(name, " = ")
    
    local valtype = type(value)

    if valtype == "number" or valtype == "string" then
        io.write(stirng.format("%q",value))
    elseif valtype == "table" then
        if saved[value] then
            io.write(saved[value],"\n")
        else
            saved[value] = name
            io.write("{}\n")

            for k, v in pairs(value) do
                k = string.format("%q", k)
                local fname = string.format("%s[%s]", name, k)
                save(fname,v,saved)
            end
        end
    else
        error("Cannot save a "..valtype)
    end
end
```

This will generate a file with all
the assignments needed to recompose
the data.
For example, given
```lua
a = {x=1,y=2, {3,4,5}}
a[2] = a
a.z = a[1]
```
it will output
```lua
a = {}
a[1] = {}
a[1][1] = 3
a[1][2] = 4
a[1][3] = 5

a[2] = a -- cycle
a["y"] = 2
a["x"] = 1
a["z"] = a[1]
```
Which reconstructs `a`

If we have distinct tables that 
are connected to each other, we
can save it this way if we
provide the save `saved` table

# Chapter 16 - Compilation, execution and errors
Compilation in Lua is expensive, be careful.

`loadfile` loads a file, compiles it, an returns 
the code as a function. `dofile` is a wrapper of 
`loadfile`

Also, `loadfile` doesn't raise errors but 
returns error codes. This is, `nil` as the first
argument and an error message as its second.

`load` behaves like `loadfile`, but takes 
strings or functions as an argument. `load` 
always behaves in the global environment, that
is
```lua 
i = 0
local i = 1
f = load("print(i)")
g = function() print(i) end
f()
g()
```
will print 
```lua
0
1
```

This variables also don't have any kind of 
effect (Don't create variables, write to 
files, etc)

We can precompile Lua code with the `luac`
command. 
```bash
luac -o prog.lc prog.lua
``` 
Precompiled code can be run by
the `lua` interpreter

## Errors
Lua can't just crash, as it's designed to
be an embedded language.

To raise an error, use `error(err_msg)`

To raise an error if a condition happens,
use `assert(cond, err_msg)`. Be aware
that `assert` is a regular function, that
is, it evaluates both arguments before
execution

A program when presented with an error 
can either return an error code (`nil` or
`false` typically), or raise an error.

You should raise an error only if the 
mistake is easy to detect by other means
(like a call to `math.sin` with a table)
and return an error code if it's more
difficult (like in `io.open(fn)`, if
`fn` is not a file)

## Error-handling
To handle errors in a piece of code, 
surround the code in a function and 
provide it to `pcall`. 

`pcall` calls its first argument in
protected mode, that is, no errors will
be raised.

If the call fails, it will return `false`
and an error message

If the call succeeds, it will return 
`true` plus any values returned by the
call.

**An error message doesn't actually 
need to be a `string`, it can be any
object (like a table)**

However, if we use a string, Lua will
fill it with more information about
where the error happened.

If we know an error occurred in the 
caller function, not where it was 
detected, we can communicate this by 
supplying an extra argument to `error`

```lua
error("String expected", 2)
```

The `2` tells Lua the error happened
on level 2 in the calling hierarchy

Because `pcall` destroys part of the 
stack, we don't get part of the 
traceback. To amend this, we use 
`xpcall(func, handler)`, which calls
its second argument before the stack
unwinds. 

Useful functions to put there are: 
 * `debug.debug`, which gives you a Lua
 prompt, to figure out what's wrong
 * `debug.traceback`, which builds an 
 extended error message with a traceback

# Chapter 17 - Modules and packages

A module is "some code that can be loaded 
through the function `require` and that creates
and returns a table".

```lua
local m = require "math"
```
Assigns the table with all the functions in 
`math` to `m`.

The standard libraries are preloaded by the
interpreter

`require` is just a regular Lua function. 

The first thing it does is check that the 
module it's trying to load wasn't loaded
beforehand by checking `package.loaded`

Then, if it wasn't loaded previously, it 
looks for a Lua file with the same name using
`package.path`, and loads it with `loadfile`

If no Lua file was found, it looks for a
valid C file, using `package.cpath`, and 
loads it with `package.loadlib`

To finally load the module, `require` loads
the loader (returned by `loadfile` or 
`package.loadlib`) with 2 arguments:

 * The module name
 * The file where it got the loader  

These are usually ignored

If there was a return value, this is stored
in the table `package.loaded` for later use.

If no value was returned, and no entry in 
`package.loaded` was modified, it behaves as
if it returned true (To be able to detect it
was run in the first time)

To force require to load `modname` twice, 
clear `package.loaded.modname`

When loading a C library, all text after a 
`-` will be ignored in the name of the 
function (So `mod-v1` would be accessed by
`luaopen_mod`, not `luaopen_mod-v1`)

Lua gets the values of `package.path` from
the environment variables `LUA_PATH_5_3` or
`LUA_PATH`. In case these are not set, it 
uses its own default. 

To reference the default path, use `;;` in
the environment variables

Same with `package.cpath` and the environment
variables `LUA_CPATH_5_3` or `LUA_CPATH`

These matching rules are applied by the 
function `package.searchpath(module, path)`

## Searchers
The concept of searching for a Lua file or C 
library are two instances of the more general
concept of `searchers`

When `require` is called, it uses all of the
searchers in `package.searchers`

Before searching for Lua files or C libraries,
the `preload` searcher is used. This checks
the table `package.preload` to see if a loader
function was defined for the package provided.

## Basic approach to writing modules in Lua
```lua
local M = {}
local function new (r, i) -- Makes the function private
    reutrn {r = r, i = i}
end

M.new = new

M.i = new(0,1) -- Constant i

function M.add(c1, c2)
    return new (c1.r + c2.r, c1.i + c2.i)
end

function M.sub(c1, c2)
    return new (c1.r - c2.r, c1.i - c2.i)
end

function M.mul(c1, c2)
    return new (c1.r * c2.r, c1.i * c2.i)
end

local function inv(c) -- Makes the function private
    local n = c.r^2 + c.i^2
    return new(c.r/n, -c.i/n)
end

function M.div (c1,c2)
    return M.mul(c1, inv(c2))
end

function M.tostring(c)
    return string.format("(%g,%g)",c.r,c.i)
end

return M
```

You can substitute the final `return M` with
`package.loaded[...] = M`, which will 
explicitly set the package as loaded

Another approach is to make all the functions
local and then build the returning table at
the end

## Submodules and packages
A module is a Lua file made to be imported

A submodule is a module in some package

A package is the complete tree of modules

## Extra
If a path has no `?` in `package.path`, it 
will always be recognized as a valid path.

---

# Chapter 18 - Iterators and the generic for

## Iterators and closures
An iterator is a construction that allows us
to iterate over the elements of a collection,
usually with a function.

A call to the function represents a `next`,
when there are no more lines to be read, it
returns nil

To store state between succesive calls, 
`io.read` uses its stream structure (from C),
and user-made iterators usually use closures.
We have a factory function that creates the
actual iterable function

```lua
function values(t)
	local i = 0
	return function()
		i = i + 1
		return t[i]
	end
end
``` 

```lua
t = {10, 20, 30}
for element in values(t) do
	print(element)
end
```

Another example, to iterate over all words
of standard input
```lua
function allwords()
	local line = io.read()
	local pos = 1
	return function()
		while line do --repeat while there are lines
			local w, e = string.match(line,"(%w+)()", pos)
			if w then
				pos = e	 --next position after this word
				return w
			else
				line = io.read() -- try next line
				pos = 1		     -- start from beginning
			end
		end
		return nil -- no more line
	end
end
```

Iterators are often not easy to write, but easy to use

## Stateless operators
This operators don't use closures to keep state.
For example, `ipairs` is this kind of iterator. It returns
3 things:
 * A function as the iterator
 * An invariant state (A table)
 * An initial value (for `ipairs`, 0)

Like so:
```lua
function ipairs(t)
	return iter, t, 0
end
```
where the function `iter` is defined as:
```lua
local function iter(t,i)
	local v = t[i+1]
	if v then
		return i+1, v
	end
end
```

The for loop then calls the function given in 
the first argument and calls it with the other
2 arguments (Invariant state and initial value),
to calculate the next element without modifying
or keeping state.

`pairs` works similarly, but with the `next` 
function

## True iterators
We are actually not writing iterators, but 
generators, functions that return elements.

We can get actual iterators with a function
that, given a function, applies it over all
elements.

This used to be popular when there was no
for statement in Lua.

# Chapter 19 - Interlude: Markov chains

A little programm to pseudo-randomly predict 
what goes next in a text.

```lua
-- AUXILIARY FUNCTIONS --
function allwords() -- Iterate over words form stdin
	local line = io.read()
	local pos = 1
	return function()
		while line do
			local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
			if w then
				pos = e
				return w
			else
				line = io.read()
				pos = 1
			end
		end
		return nil
	end
end

function prefix(w1, w2)
	return w1 .. " " .. w2
end

local statetab = {}

function insert(prefix, value)
	local list = statetab[prefix]
	if list == nil then
		statetab[prefix] = {value}
	else
		list[#list + 1] = value
	end
end
io.input(io.open(arg[1] or "") or io.input())

-- ALGORITHM --
local MAXGEN = 200
local NOWORD = "\n"

-- build table
local w1, w2 = NOWORD, NOWORD
for nextword in allwords() do
	insert(prefix(w1, w2), nextword)
	w1 = w2;
	w2 = nextword;
end
insert(prefix(w1, w2), NOWORD)

--generate text
w1 = NOWORD
w2 = NOWORD
for i = 1, MAXGEN do
	local list = statetab[prefix(w1, w2)]
	local r = math.random(#list)
	local nextword = list[r]

	if nextword == NOWORD then goto break end
	io.write(nextword, " ")
	w1 = w2
	w2 = nextword
end
::break::
io.write("\n")
```

# Chapter 20 - Metatables and metamethods
For tables and userdata, we can predefine their
behaviour when added, substracted and operated
in general using _metamethods_, defined in a 
_metatable_.

_metatables_ are just tables with special 
methods, the _metamethods_

`setmetatable(obj, table)` sets _metatables_  
`getmetatable(obj)` returns _metatables_

Other type's _metatables_ can be modified 
using the debug library or C code.

`strings` have a common predefined _metatable_

## Metamethods

### Arithmetic
When looking for a arithmetic metamethod,
Lua will look first in the metatable of the 
first operand, then in the metatable of the 
second operand, and if nothing is available,
raise an error.
* `__add`
* `__mul`
* `__sub`
* `__div` Float division
* `__idiv` Integer division
* `__unm` Unary minus
* `__mod`
* `__pow` 
* `__len` `#` operator
* `__band` `&` operator
* `__bor` `|` operator
* `__bxor` `~` operator
* `__bnot` `~` operator (unary)
* `__shl` `<<` operator
* `__shr` `>>` operator
* `__concat` `..` operator
* `__call` `()` operator

### Relational
When looking for a relational metamethod,
Lua will check that both operands share the
same metatable.
* `__eq`   
  Also used in `~=`
* `__lt`   
  Also used in `>`
* `__le`   
  Also used in `>=`

### Library-defined metamethods
* `__tostring`
* `__metatable` What to return with 
`getmetatable`. When set, `setmetatable` 
will always return an error
* `__pairs` What `pairs` calls to if it's
defined

### Table-access methods
* `__index` Define what to return after an 
unsuccessful access attempt in a table.  
Accepts a table instead of a function  
To avoid calling this method, use `rawget(t,k)`
* `__newindex` Define what to do when
assigning a value to an absent key in the
table  
To avoid calling this method, use `rawset(t,k,v)`

## Tracking table accesses
As table access can only be monitored
when using a key not in the table, the
actual table must be empty and only 
serve as a proxy to another table 
contained in the _metatable_

```lua
function track(t)
	local proxy = {}

	local mt = {
		__index = function(_, k)
			print("*access to element " .. tostring(k))
			return t[k]
		end,

		__newindex = function(_, k, v)
			print("*update of element " .. tostring(k) ..
			      " to " .. tostring(v))
			t[k] = v
		end,

		__pairs = function()
			return function(_, k)
				local nextkey, nextvalue = next(t, k)
				if nextkey ~= nil then
					print("*traversing element " .. tostring(nextkey))
				end
				return nextkey, nextvalue
			end
		end,

		__len = function() return #t end
	}

	setmetatable(proxy, mt)

	return proxy
end
```

From this, it's easy to implement a read-only
table. Just replace the `__newindex` method
with something that does nothing / raises an
error.

# Chapter 21 - Object-Oriented Programming

`table:func(...)` is just syntactic sugar for
`table:func(table, ...)`

With this and tables, we can already have the
concept of methods, attributes and state.

## Class definitions

For inheritance, we can use the approach of 
prototype-based languages like JavaScript.
Objects don't have classes but prototypes, 
which are objects where they look for values
they themselves don't know

`setmetatable(A, {__index = B})` makes B a 
prototype of A

#### Example of class behaviour when calling a method
This is the preliminary code we have
```lua
-- Some table Accout, acts as class
local mt = {__index = Account}

function Account.new (o)
	 o = o or {}
	 setmetatable(o, mt)
	 return o
end

a = Account.new{balance = 0}
```
Therefore, whatever table we create from
`Account.new` (like `a`), has `Account` as its 
prototype.

Now, let's analyze what happens here:
```lua
a:deposit(100.00)
```
This is just syntactic sugar for
```lua
a.deposit(a, 100.00)
```
Since `a` doesn't have a field `deposit`, we
look at the `__index` method for instructions.
Here, `__index` is a table.
```lua
getmetatable(a).__index.deposit(a, 100.00)
```
However, the `__index` method is told to look
in the `Account` table, so finally, what Lua
performs is the following operation
```lua
Account.deposit(a, 100.00)
```
which is the `deposit` function defined inside
of the table `Account`, but with the `self`
keyword assigned to `a`.

As an improvement to the following scheme, we
can make `mt`'s methods be a part of the 
`Account` table.

Also, we can modify the `new` method so it takes
a `self` argument as well
```lua
function Account:new(o)	 
	o = o or {}
	self.__index = self
	setmetatable(o, self)
	return o
end
```
so when we call `Account:new()`, `o`'s _metatable_
is `Account`, where we did previously
`Account.__index = Account`, which means _"for any
table I'm its metatable, look within me for unknow
keys"_

This second change may seem unnecessary, but it
proves its worth after we talk about inheritance

## Inheritance
If we invoke the `new` method of a class from an 
instance of a class, we are creating but a new 
object that inherits from it. Therefore, to 
implement class inheritance, we have but to create
a new instance of the parent class, modify it as 
we wish, and then use it as a class to define new
objects. This is the advantage of making `new` a 
method

```lua
local A = { yes = true }
function A:new (o)
	 o = o or {}
	 self.__index = self
	 setmetatable(o, self)
	 return o
end
local B = A:new{ msg = "yes" }
a = A:new()
b = B:new()
```
In this example, `a`'s prototype (Or _metatable_) 
is `A`, but `b`'s prototype is `B`

If we look for `b.yes`, Lua will look at its
_metatable_, `B`, which will redirect to its
_metatable_, `A`, which has the method we were
looking for

## Multiple inheritance
For multiple inheritance, just replace the `.__index`
method to use a function that looks for the methods
in various classes.
```lua
local function search(k, plist)
	for i = 1, #plist do
		local v = plist[i][k]
		if v then return v end
	end
end

function createClass(...)
	local c = {}
	local parents = {...}
	setmetatable(c, {.__index = function(_, k)
		return search(k, parents)
	end)
	c.__index = c -- Make it behave like a class
	function c:new(o) -- Create constructor
		 o = o or {}
		 setmetatable(o,c)
		 return o
	end
	return c
end
```

# Chapter 22 - The environment
As an approximation, we can think that Lua keeps
its global variables in a table ,`_G`, called the
global environment.

You can do some metaprogramming and access a 
variable who's name is stored in another variable
using this table.
```lua
_G[varname]
```

You can restrict the use of global variables 
using metatables on `_G`, overwriting the 
`__newindex`. 

`strict.lua` is a module that implements the 
restriction of not allowing global variables
to be declared inside of functions (With clever
use of the `debug.getinfo(2,"s")` method). It's
good practice to use it.

Global variables are an illusion. The Lua compiler
translates any free names `n` to `_ENV.n`, where
a free name is a possible variable name not being
used in the local scope.

The `_ENV` variable also can't be a global 
variable, since Lua doesn't have global variables.

When a chunk is compiled into an anonymous 
function, the `_ENV`variable is defined, local to
that chunk, and taking as an original value the 
global environment (Which Lua keeps track of on
its own)

We can modify `_ENV` to alter the environment of
certain code chunks, if you wish.

If we do not wish to permanently changed the 
environment, for example, we could do this:
```lua
local newgt = {}
setmetatable(newgt, {__index = _G})
_ENV = newgt
```
This way, new assignments go to `newgt` but all
values are inherited from `_G`.

`_ENV` follows the scoping rules of regular 
values.

You can pass `loadfile` and `load` an extra 
argument with the environment table to use.

In case you want to use different environments
in the same code chunk and don't wish to 
recompile the chunk every time, you can use
`debu.setupvalue(function, index, value)` to
change the _upvalue_ at index `index` to `value`

This is kind of messy, as it requires that we
use the `debug` library. We can circumvent this
by prepending the chunk of code this `_ENV = ...`
which will ensure that the first argument will 
be set as the environment of the following 
chunk. 

Recall that **upvalues** or **non-local variables** 
are variables used inside a function constructor 
but defined elsewhere.

# Chapter 23 - Garbage

God bless the garbage collector. It isn't a 
perfect being, so we as programmers can help it

## Weak tables
A weak reference is a reference that is not 
considered by the garbage collector. A weak table
is a table whose entries are weak. Both keys and
values of a table can be weak referenced. Which
are the weak references can be distinguished 
through the _metamethod_ `__mode`

* `__mode = "k"` means keys are weak
* `__mode = "v"` means values are weak
* `__mode = "kv"` means keys and values are weak

Else, the table is considered to have no weak
references

If a weak reference on a table is eliminated, 
the entire entry is removed, regardless of whether
it was a key or a value

`collectgarbage()` forces a garbage collection
cycle

### Memorize functions

Use weak tables to memorize function results to
speed computing times

### Object attributes

To keep an object's attributes private, we can
store them in a table and use the object as the
keys to access them. This is called 
**dual-representation**

Instead of 
```lua
o = {
	x = 10,
	y = 30
}
```
we do
```
o, x, y = {}, {}, {}
x[o] = 10
y[o] = 30
```

To make this work, the keys on the `x` and `y`
tables must have their keys be weak references.

However, the table can't hold weak values, or
attributes of live objects could be collected

### Default values in tables

We can implement this using dual-representation
or memorization.

Dual-representation would be having a weak 
table with each table's default, so we only
have to define one _metatable_ that accesses it
to look for each objects default

Memorization would be having a function that
returns _metatables_ depending on the default
value selected, but remembers if a past default
value was used and returns the same _metatable_

### Ephemeron tables

If in a table with weak keys, a value refers to
its own key, we have a problem. 

Picture a table that maps an object to a function
that uses that object (Not that weird if we think
of a memorization of a function)

```lua
mem[o] = (function() return o end)
```

Then, the `o` object is always being referenced, 
so even if `mem` is a weak table, this entry will
never get deleted.

To solve this, `"kv"` weak tables in Lua are 
_ephemeron tables_, which means that for an entry
`(k,v)`, a reference to `v` is only strong if 
there is a strong reference to `k` as well.

## Finalizers
These are functions to be called when an object
is about to be collected.

The function is provided via the _metamethod_
`__gc`

```lua
o = setmetatable({x=1}, {__gc = function(o) print(o.x) end})
```

Lua doesn't look for finalizers every time it 
deletes an object. Instead, Lua stores a list of 
objects that have finalizers, to know if it has to
call them or not. This can have bizarre consequences
if you set a `__gc` metamethod to a metatable after
you have assigned it to an object. Since at the 
moment of declaration that object didn't have a 
`__gc` metamethod, Lua didn't mark it for 
finalization so `__gc` will not be called, even 
when the metamethod isn't `nil` once it happens.

Lua makes garbage collection of objects marked
for finalization in 2 phases. Since the `__gc` 
metamethod receives the object as its first parameter,
`__gc` could _resurrect_ it by assigning it to 
a global variable.
 * On the first phase, an oject marked for 
 finalization with no strong references left is found
 by Lua, who runs their `__gc` metamethod, and marks 
 them as finalized.

 * On the second phase, an object marked as finalized
 with no strong references left is deleted, since 
 their finalizer was already called.

We are guaranteed that a finalizer of an object runs
exactly once

One more subtlety with weak tables: the collector 
clears the values in a weak table before calling the
finalizer, but clears the keys after it.

## The garbage collector

Up to 5.0, it was a _mark-and-sweep_ garbage collector  
In 5.1, it was a _incremental_ garbage collector  
In 5.2, it was a _emergency_ garbage collector  

All collectors perform this 4 phases:
 * **Mark:**  
   All reachable objects are marked as alive
 * **Cleaning:**  
   Lua handles finalizers and weak tables: 
   1. Look for objects marked for finalization
   with no references, and separate them in a list
   2. Traverse the weak tables and delete entries
 * **Sweep:**  
  Collects objects not marked as alive, or clears
  its alive mark
 * **Finalization:**  
  Calls the finalizers of the objects separated in 
  the cleaning phase

## `collectgarbage()`

`collectgarbage("stop")` stops the collector until
another call with `"restart"`

`collectgarbage("restart")` see above

`collectgarbage("collect")` performs a garbage 
collection cycle

`collectgarbage("step", data)` does the work 
equivalent to what it would do after allocating
`data` bytes. `data=0` means minimal steps

`collectgarbage("count")` returns the number of kB
of memory currently in use by Lua. This is a double, 
multiplied by 1024 gives the exact number of bytes

`collectgarbage("setpause", data)` sets the 
collector's `pause` parameter. `data` is a percentage,
i.e. `data=100` would be a 100%

`collectgarbage("setstepmul", data)` sets the 
collector's step multiplier parameter `stepmul`.`data`
is a percentage, i.e. `data=100` would be a 100%

With garbage collectors (GC), we trade memory for CPU 
time.

The `pause` parameter controls how much the GC waits
before doing another cycle. A pause of `data` waits
for memory usage to reach `data`% of what it is now
to perform another cycle. Keep between 0 and 200  
↓ pause ←→ ↓ memory ←→ ↑ time

The `stempul` parameter controls how much work the
collector does for each kB of data. Below 100% would
make it too slow. The default is 200%

# Chapter 24 - Coroutines

Coroutines are similar to threads, except that 
coroutines are collaborative. At any given time, a 
program with coroutines is running only one of its
coroutines, and this running coroutine suspends its
execution only when it explicitly requests to be
suspended.

All of this functionality is accessed through the 
`coroutine` table

Coroutines are created through the function 
`coroutine.create(f)` command, which takes a single
argument, a function with the code the coroutine 
will run (the body)

A coroutine can be in one of four states:
 * suspended _(Default in creation)_
 * running
 * normal
 * dead

Check for state using the `coroutine.status(co)`

Resume or start a coroutine with the function
`coroutine.resume(co)` in protected mode, which 
means that errors are returned, not shown. If the
coroutine is dead, it also returns `false` and an 
error message.  
It returns `true` if no errors happened, plus all
the arguments passed to `yield`, if that's how
it got recalled, or the return values of the 
function  
You can also pass `coroutine.resume(co,...)` extra
arguments to pass to a `coroutine.yield()` 
statement

When all the body of a coroutine is finished, the
coroutine enters the dead state.

The power of coroutines comes from the function
`coroutine.yield()`, which allows a coroutine to
suspend its own execution to be resumed later.
Any arguments passed to `yield` will be received 
by the function who called `.resume` on it.

If a running coroutine calls another coroutine,
it enters normal state, since it cannot be 
suspended (You can't resume it), but it's also 
not running.

Lua offers _asymmetric coroutines_, which means
that there are two distinct functions to:
 1. Suspend the execution of a coroutine
 2. Resume a suspended coroutine

#### Example of producer-consumer pattern
```lua
function receive(prod)
	local status, value = coroutine.resume(prod)
	return value
end

function send(x)
	coroutine.yield(x)
end

function producer()
	return coroutine.create(function()
		while true do
			local x = io.read() -- Produce new value
			send(x)
		end
	end)
end

function filter (prod)
	return coroutine.create(function()
		for line = 1, math.huge do
			local x = receive(prod) -- get new value
			x = string.format("%5d %s", line, x)
			send(x) 	-- send to consumer
		end
	end)
end

function consumer (prod)
	while true do
		local x = receive(prod)
		io.write(x, "\n")
	end
end
```

We can use coroutines to implement iterators 
without worrying about keeping state.

For example, we can iterate over permutations
of a list like this

```lua
function permgen(a, n)
	n = n or #a
	if n <= 1 theen
		coroutine.yield(a)
	else
		for i = 1, n do
			a[n], a[i] = a[i], a[n] -- swap
			permgen(a, n-1)
			a[n], a[i] = a[i], a[n] -- swap (restore)
		end
	end
end

function permutations(a)
	local co = coroutine.create(function() permgen(a) end)
	return function()
		local code, res = coroutine.resume(co)
		return res
	end
end
```

To simplify `permutations`, we can use the 
function `coroutines.wrap(f)`, which takes
a function `f` and returns a function that
resumes a created coroutine with body `f`.

`wrap` doesn't return error codes, so use 
is sometimes more convenient, but less 
flexible regarding errors.

The `permutations` function would end up like 
this
```lua
function permutations(a)
	return coroutine.wrap(function() permgen(a) end)
end
```

## Event-driven programming

Trying to understand this example:

Async library simulation:
```lua
-- async-lib.lua
lib.runloop() -- Start the event loop
lib.readline(stream, callback) -- Fire read-line event
lib.writeline(stream, line, callback) -- Fire writen-line event
lib.stop() -- Stop the event loop
```

A program to print the lines in reverse orther 
would look something like this
```lua
local lib = require "async-lib"

local t = {}
local inp = io.input()
local out = io.output()
local i 

local function putline()
	i = i-1
	if i == 0 then
		lib.stop()
	else
		lib.writeline(out, t[i].."\n", putline)
	end
end

local function getline(line)
	if line then
		t[#t + 1] = line
		lib.readline(inp, getline)
	else
		i = #t + 1
		putline()
	end
end

lib.readline(inp, getline)
lib.runloop()
```

# Chapter 25 - reflection

The `debug` library comprise 2 kinds of 
functions:
 * Introspective functions  
   Inspect aspects of the running program (stack,
   current exec line, values and names of 
   variables)
 * Hooks
   Allows us to trace the execution of the program

Use `debug` scarcely. It's sometimes not performant.

## Introspective facilities

`getinfo` is the main one. Takes a function or stack 
level as its first argument.

When called with a function, it returns a table with
(possibly) the following fields:

 -  `source` "@filename" or "code", if it was a loaded
    string

 - `short_src` short version (up to 60 chars) of above

 - `linedefined` first line number where it was defined

 - `lastlinedefined` same as above, but last

 - `what` "Lua", if it's a regular function, "C" if it
    is a C function, or "main" if its the main part of
	a Lua chunck.

 - `name` reasonable name for the function

 - `namewhat` "global", "local", "method", "field" or 
    "" if nothing was found

 - `nups` number of upvalues (values from outside)

 - `nparams` number of parameters

 - `isvararg` whether function is variadic

 - `activelines` number of lines with code (not empty)

 - `func` has the function itself

If we provide a number, information is returned about 
the function at that stack level, where 0 is `getinfo`
and `nil` is returned if the number given is too large

Since `getinfo` isn't performant, you can supply it 
with a list of information to look for as a second 
argument, which takes a string with characters.
 
 - `n` selects `name` and `namewhat`
 - `f` selects `func`
 - `S` selects `source`, `short_src`, `what`, 
       `linedefined` and `lastlinedefined`
 - `l` selects `currentline`
 - `L` selects `activelines`
 - `u` selects `nup`, `nparams` and `isvararg`

`traceback` returns a string with traceback information

### Accessing local variables

With `getlocal(stack_level, idx)` get the `idx`-th 
variable at `stack_level`. These are ordered from oldest
to newest.

Negative indexes get information about extra arguments
of variadic functions. 

With `getupvalue`, you can access upvalues. Provide a 
function instead of `stack_trace`.

You can update upvalues with `setupvalue`

### Accessing coroutines

When a coroutine fails, it doesn't unwind its own stack.
We can provide most `debug` library functions a coroutine
to see information about it.

## Hooks

You can ask Lua to run functions at certain events.
These are:
 1. Call events (When Lua calls a function)
 2. Return events (When a function returns)
 3. Line events (When Lua executes a new line of code)
 4. Count events (After a given number of instructions)

Register hooks with 
`debug.sethook(function, mask_string[, count])`. The
mask string specifies the event to hook too by their
first letter (`"c"`, `"r"`, `"l"`), except count events.
For those just specify a `count`.

`debug.debug()` opens a Lua prompt (Using the global 
environment) and allows the user to execute commands
until `cont` is entered.

## Profiles
Profiling is analysing the behaviour of a program 
regarding its use of resources (i.e. time and memory)

Usually, it's best to use the C interface. For counting,
Lua is fine

## Sandboxing

We saw how to restrict function usage by using `_ENV`

You can control the number of instructions run with a
hook

You can control the amount of memory used with the
`collectgarbage("count")` function, by hooking it
to each line. It should be called pretty frequently
though, as memory can grow fast

Functions of the `string` library can be accessed
through the strings metatable, even when it's
restricted through `_ENV`. A way to combat this 
is to check in every function call if the function
is permitted

As a rule of thumb:
 * Functions from `math` are safe
 * Functions from `string` are safe, though they 
   can be resource intensive
 * Functions from `package` and `debug` are **dangerous**
 * `setmetatable` and `getmetatable` can be dangerous,
   because of finalizers possibly overcoming the 
   sandboxing and metamethods being used to circumvent
   it

# Chapter 26 - Interlude: Multithreading with coroutines

You can pseudo-implement multithreading with coroutines.
It works in mysterious ways, I haven't really understood
completely, I think. I might have to revisit it.


