{
  "baseUri": "/",
  "restApiRoot": "/api",
  "host": process.env.HOST || "0.0.0.0",
  "port": process.env.PORT || "8000",
  "aclErrorStatus": 403,
  "remoting": {
    "context": {
      "enableHttpContext": true
    },
    "rest": {
      "normalizeHttpPath": true,
      "xml": false
    },
    "json": {
      "strict": true,
      "limit": "100kb"
    },
    "urlencoded": {
      "extended": true,
      "limit": "100kb"
    },
    "cors": false,
    "errorHandler": {
      "disableStackTrace": true
    }
  },
  "legacyExplorer": false
}
