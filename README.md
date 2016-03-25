## Playing with ActionCable

This repository is an incredibly simple Rails server that includes an ActionCable channel. I wanted to experiment with ActionCable specifically to see how it performs under load.

To run the tests:

* Start the server `rails s -b 0.0.0.0` ([don't use localhost](https://twitter.com/mattheworiordan/status/713350750483693568))
* Open a browser to `https://localhost:3000`, this will open a single connection and channel subscription
* Create 2,500 connections each with a single channel subscription `node test-actioncable.js`

### [Ably realtime messaging](https://www.ably.io)

A test script exists to connect to Ably and publish a high volume of messages quickly, see [test-ably.js](./test-ably.js). However, please note that your tests may not provide useful results for the following reason:

* The websocket servers are not local so there is increased latency
* You need an account and API key to connect to Ably, [sign up for a free account first](http://www.ably.io/signup)
* You need to [obtain your API key from your dashboard](https://support.ably.io/solution/articles/3000030054-what-is-an-app-api-key) and add it to the [test-ably.js](./test-ably.js) script.
