var counter = require('../lib/');

counter(function(error, counts) {
  if (error) {
    console.error(error);
  } else {
    console.log(counts);
  }
});
