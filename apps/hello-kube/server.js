var http = require('http');

var handleRequest = function(request, response) {
        console.log('Received request for URL: ' + request.url);
	response.writeHead(200);
	response.end('{"message": "Hello Kubernetes World! Ship to container!", "version" : "2.0"}');
};

var www = http.createServer(handleRequest);

www.listen(8080);
