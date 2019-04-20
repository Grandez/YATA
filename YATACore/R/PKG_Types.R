percentage <- function(value) {
    result <- value
    class(result) <- c("percentage", class(value))
    result
}
print.percentage <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

`+.percentage` <- function(x, y)     { NextMethod() }
`-.percentage` <- function(x, y)     { NextMethod() }
`/.percentage` <- function(x, y)     { NextMethod() }
`*.percentage` <- function(x, y)     { NextMethod() }
`^.percentage` <- function(x, y)     { NextMethod() }

as.percentage <- function(x) { percentage(x) }

fiat <- function(value) {
    result <- value
    class(result) <- c("fiat", class(value))
    result
}
print.fiat <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

`+.fiat` <- function(x, y)     { NextMethod() }
`-.fiat` <- function(x, y)     { NextMethod() }
`/.fiat` <- function(x, y)     { NextMethod() }
`*.fiat` <- function(x, y)     { NextMethod() }
`^.fiat` <- function(x, y)     { NextMethod() }

as.fiat <- function(x) { fiat(x) }

ctc <- function(value) {
    result <- value
    class(result) <- c("ctc", class(value))
    result
}
print.ctc <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    sprintf("%.06f", x)
}

`+.ctc` <- function(x, y)     { NextMethod() }
`-.ctc` <- function(x, y)     { NextMethod() }
`/.ctc` <- function(x, y)     { NextMethod() }
`*.ctc` <- function(x, y)     { NextMethod() }
`^.ctc` <- function(x, y)     { NextMethod() }

as.ctc <- function(x) { ctc(x) }

long <- function(value) {
    result <- value
    class(result) <- c("long", class(value))
    result
}

print.long <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

`+.long` <- function(x, y)     { NextMethod() }
`-.long` <- function(x, y)     { NextMethod() }
`/.long` <- function(x, y)     { NextMethod() }
`*.long` <- function(x, y)     { NextMethod() }
`^.long` <- function(x, y)     { NextMethod() }

as.long <- function(x) { long(x) }

number <- function(value) {
    result <- value
    class(result) <- c("number", class(value))
    result
}

print.number <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

`+.number` <- function(x, y)     { NextMethod() }
`-.number` <- function(x, y)     { NextMethod() }
`/.number` <- function(x, y)     { NextMethod() }
`*.number` <- function(x, y)     { NextMethod() }
`^.number` <- function(x, y)     { NextMethod() }

as.number <- function(x) { number(x) }

dated <- function(value) {
    result <- value
    class(result) <- c("dated", class(value))
    result
}

print.dated <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

as.dated <- function(x) { dated(x) }

datet <- function(value) {
    result <- value
    class(result) <- c("datet", class(value))
    result
}

print.datet <- function(x, ...) {
    x <- unclass(x)
    attributes(x) <- NULL
    NextMethod()
}

as.datet <- function(x) { datet(x) }
