let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/App/*.purs" ],
  dependencies = conf.dependencies # [ "httpure" , "affjax", "affjax-web", "node-fs-aff", "js-timers", "web-storage"]
}