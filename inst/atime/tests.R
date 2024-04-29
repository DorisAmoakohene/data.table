pkg.edit.fun=function(old.Package, new.Package, sha, new.pkg.path){
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
  }

new.git = list(
  pkg.edit.fun = quote(pkg.edit.fun),
  N = 10^seq(1, 7),
  setup = quote({
    L <- replicate(N, 1, simplify = FALSE)
    setDT(L)
  }),
  expr = quote({
    data.table:::setattr(L, "class", NULL)
    data.table:::setDT(L)
  }),
  Slow = "c4a2085e35689a108d67dacb2f8261e4964d7e12",
  Fast = "1872f473b20fdcddc5c1b35d79fe9229cd9a1d15")
