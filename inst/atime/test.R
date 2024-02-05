test.list <- list(
  shallow.4440 = list(
    pkg.edit.fun=quote(function(old.Package, new.Package, sha, new.pkg.path){
      
      pkg_find_replace <- function(glob, FIND, REPLACE){
        atime::glob_find_replace(file.path(new.pkg.path, glob), FIND, REPLACE)
      }
      Package_regex <- gsub(".", "_?", old.Package, fixed=TRUE)
      Package_ <- gsub(".", "_", old.Package, fixed=TRUE)
      new.Package_ <- paste0(Package_, "_", sha)
      
      pkg_find_replace(
        "DESCRIPTION",
        paste0("Package:\\s+", old.Package),
        paste("Package:", new.Package))
      pkg_find_replace(
        file.path("src","Makevars.*in"),
        Package_regex,
        new.Package_)
      pkg_find_replace(
        file.path("R", "onLoad.R"),
        Package_regex,
        new.Package_)
      pkg_find_replace(
        file.path("R", "onLoad.R"),
        sprintf('packageVersion\\("%s"\\)', old.Package),
        sprintf('packageVersion\\("%s"\\)', new.Package))
      pkg_find_replace(
        file.path("src", "init.c"),
        paste0("R_init_", Package_regex),
        paste0("R_init_", gsub("[.]", "_", new.Package_)))
      pkg_find_replace(
        "NAMESPACE",
        sprintf('useDynLib\\("?%s"?', Package_regex),
        paste0('useDynLib(', new.Package_))
    }),
    N = quote(10^seq(3, 8)),
    expr = quote(data.table:::shallow(dt)),
    setup = quote({
      set.seed(1L)
      dt <- data.table(a = sample(N, N))
      setindex(dt, a)
    })
  )
)
