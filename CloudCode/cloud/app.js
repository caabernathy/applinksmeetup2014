// For Express
var express = require('express');
// For app links metatags
var appLinks = require('applinks-metatag');
var app = express();

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body

// Bird
app.get('/bird', appLinks({
  platform: "ios",
  url: "measureapplinks://bird",
  app_name: "Measure App Links"
}), function(req, res) {
  res.render('animal', { message: 'This is a bird.' });
});

// Dog
app.get('/dog', appLinks({
  platform: "ios",
  url: "measureapplinks://dog",
  app_name: "Measure App Links"
}), function(req, res) {
  res.render('animal', { message: 'This is a dog.' });
});

// Attach the Express app to Cloud Code.
app.listen();
