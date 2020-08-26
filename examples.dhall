let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/**/*.purs" ],
  dependencies = conf.dependencies # [ "httpure" , "websocket-simple", "affjax", "node-fs-aff", "node-http" ]
}