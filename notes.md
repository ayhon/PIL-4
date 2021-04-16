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

# Chapter 2 - Interlude, The Eight-Queen puzzle
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
Because 1 char $\not\rightarrow$ 1 byte, we have to take measures
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
> x, y = foo()	  -- x = 1, y = 2
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
		body = string.sub(body, 2, -2) 		-- get rid of { }
		body = latex2xml(body) 			   	-- handle nested commands
		return string.format("<%s> %s </%s>", tag, body, tag)
	end
end
```

An emtpy capture (`()`) captures its position in the subject
string.  A good example of its use is in tab expansion
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
