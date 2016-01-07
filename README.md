# bootstraps
Use gulp and webpack to speed up your development.

1. add dependent modules to package.json
2. checkout webpack.config.coffee, update the configuration to fit your application
3. update the server/watch tasks in gulpfile.coffee
4. run ````gulp dev````
5. to use the hot module reload feature of webpack, you will need to use the full url of the js files with the dev server host/port in your view files, like "http://127.0.0.1:3000/js/app.js", and run ````gulp hotdev````