# comp to straight arrays


# vectors can have names
f_nv <- c("coal" = 100, "ng" = 150)

# assigning two names this way doesn't work
f_na <- c(c("coal", "2005") = 100, c("coal", "2015") = 200, c("ng", "2005") = 150, c("ng", "2015") = 175)


# you *CAN* have names along each dimension
f_a <- array(c(100, 200, 150, 175), dim = c(2, 2), dimnames = list(c("coal", "ng"), c("2005", "2015")))

f_a["coal", "2005"]

f_a["coal",]
f_a[, "2005"]
f_a[c("coal", "ng"), c("2005", "2015")]

fuel <- c("coal", "ng")
yr   <- c("2005", "2015")

f_a[fuel, yr]
f_a[fuel, ]
f_a[, yr]

