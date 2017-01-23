# Quick Start

## Install dependencies

`npm install`


## Start up service
install globally `webpack` and `webpack-dev-server`
`npm install -g webpack`
`npm install -g webpack-dev-server`

run
`webpack-dev-server`

## Open

`localhost:8080`


## Build static resource
`webpack --profiles=testing [-d]`


### Create Cust project
1.	Checkout cust folder completely.
2.	From command prompt in core directory execute following:
webpack --config .\webpack-customize.config.js --profiles=coreinternal

-- This will refresh the contents of cust directory using the content of core.
3.	Check in cust folder.
