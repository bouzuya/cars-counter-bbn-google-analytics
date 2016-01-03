# cars-counter-bbn-google-analytics

A [bouzuya/cars][] counter for the Google Analytics tag in blog.bouzuya.net

## Installation

```
$ npm install --save bouzuya/cars-counter-bbn-google-analytics
```

## Configuration

1) Create a "service account key"

https://console.developers.google.com/apis/credentials

New credentials > Service account key > Create (key type: JSON)

2) Add client_email to Google Analytics settings

Copy "client_email" value in created json file.

Add "Read & Analyze" permission to your ”client_email".

Admin > VIEW > User Management > Add permission for ... > Input client_email and select "Read & Analyze".

3) Set environment variables

```
$ export GOOGLE_ANALYTICS_VIEW_ID='...' # e.g. '99999999'
$ export GOOGLE_ANALYTICS_CLIENT_EMAIL='...' # e.g.  'xyz-999@xyz999.iam.gserviceaccount.com'
$ export GOOGLE_ANALYTICS_PRIVATE_KEY='...' # e.g. '"-----BEGIN PRIVATE KEY-----\n..."'
```

## License

[MIT](LICENSE)

## Author

[bouzuya][user] &lt;[m@bouzuya.net][email]&gt; ([http://bouzuya.net][url])

[user]: https://github.com/bouzuya
[email]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
[bouzuya/cars]: https://github.com/bouzuya/cars
