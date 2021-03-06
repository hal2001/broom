context("rq tidiers")

library(quantreg)

test_that("rq tidiers work", {
  skip_if_not_installed("quantreg")
  data(stackloss)
  fit <- rq(stack.loss ~ stack.x, .5)
  td <- tidy(fit)
  check_tidy(td, exp.row = 4, exp.col = 5)

  single_covariate_fit <- rq(stack.loss ~ 1, .5)
  td <- tidy(single_covariate_fit)
  check_tidy(td, exp.row = 1, exp.col = 5)

  td <- tidy(fit, se.type = "iid")
  check_tidy(td, exp.row = 4, exp.col = 8)

  au <- augment(fit)
  check_tidy(au, exp.row = 21, exp.col = 5)

  au <- augment(fit, interval = "confidence")
  check_tidy(au, exp.row = 21, exp.col = 7)

  au <- augment(fit, newdata = stackloss)
  check_tidy(au, exp.row = 21, exp.col = 6)

  gl <- glance(fit)
  check_tidy(gl, exp.col = 5)
})

test_that("rqs tidiers work", {
  skip_if_not_installed("quantreg")
  fit <- rq(Ozone ~ ., data = airquality, tau = 1:19 / 20)
  td <- tidy(fit)
  check_tidy(td, exp.row = 114, exp.col = 5)
  
  single_covariate_fit <- rq(Ozone ~ Temp - 1, data = airquality,
                             tau = 1:19 / 20)
  td <- tidy(single_covariate_fit)
  check_tidy(td, exp.row = 19, exp.col = 5)

  rqs_glance_error <- paste(
    "`glance` cannot handle objects of class 'rqs',",
    "i.e. models with more than one tau value. Please",
    "use a `purr::map`-based workflow with 'rq' models instead."
  )
  
  expect_error(glance(fit), regexp = rqs_glance_error)

  au <- augment(fit)
  check_tidy(au, exp.row = 2109, exp.col = 9)

  au <- augment(fit, newdata = airquality)
  check_tidy(au, exp.row = 2907, exp.col = 8)
})

test_that("nlrq tidiers work", {
  skip_if_not_installed("quantreg")
  set.seed(1)
  Dat <- NULL
  Dat$x <- rep(1:25, 20)
  Dat$y <- SSlogis(Dat$x, 10, 12, 2) * rnorm(500, 1, 0.1)
  fit <- nlrq(y ~ SSlogis(x, Asym, mid, scal), data = Dat, tau = 0.5, trace = FALSE)
  td <- tidy(fit, conf.int = TRUE)
  check_tidy(td, exp.row = 3, exp.col = 7)

  gl <- glance(fit)
  check_tidy(gl, exp.col = 5)
})
