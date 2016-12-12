# Bash minify

Minifies bash scripts

## Usage

Bashminify takes a filename as arugment and prints the resulting script to stdout

```
./bashminify.sh myscript.sh > myscript.min.sh
```

Calling `myscipt.min.sh` should now be equivalent to calling `myscript.sh`.

## Features

### Size reduction

Removes comment lines and empty (or pure whitespace) lines. Maybe I'll add support for inline comments later, but that will be more complicated because that essentially requires most features of a full bash parser...

### File inclusion

If `myscript.sh` includes any other scripts with `source` or `.`, they will be included directly in the resulting file.

For example:

```
# myscript.sh
source otherscript.sh
echo "${var}"
```

```
# otherscript.sh
var="Hello World"
```

Calling bashminify on `myscript.sh` will now include the source of `otherscript.sh`, we therefore move `otherscript.sh` around in the filesystem afterwards without worrying about breaking the minified script.

```
> ./bashminify.sh myscript.sh
var="Hello World"
echo "${var}"
>
```

Note, however, that the source command can't share a line with another command in `myscript.sh`, otherwise this won't work.
