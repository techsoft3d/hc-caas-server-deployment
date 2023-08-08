const express = require('express');
const cors = require('cors');
const path = require('path');

const caas = require('ts3d.hc.caas');
const caas_um = require('ts3d.hc.caas.usermanagement');

const http = require("http");
const https = require("https");

const config = require('config');
const fs = require('fs');

(async () => {

  if (config.has("startCaaS") && config.get("startCaaS")) {
    await caas.start();
  }

  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
  var httpProxy, proxy, app = null;
  if (config.has("startProxy") && config.get("startProxy")) {
    app = express();
    httpProxy = require('http-proxy');
    proxy = httpProxy.createProxyServer({});
    app.use(cors());
  }

  if (config.has("startUM") && config.get("startUM")) {
    caas_um.start(app, null, { createSession: false, sessionSecret: "12345" });
  }

  let server;

  if (app) {

    if (config.has("serveHCDemoSite") && config.get("serveHCDemoSite")) {
      console.log("Serving HC Demo Website");
      app.use("/demo.techsoft3d.com", express.static(path.join(__dirname, '/hc-demoapp-frontend')));
      app.get('/demo.techsoft3d.com', function (req, res) {
        res.sendFile(__dirname + '/hc-demoapp-frontend/index.html');
      });
    }


    if (config.has("ssl.keyPath") && config.get("ssl.keyPath") != "") {
      const options = {
        key: fs.readFileSync(config.get("ssl.keyPath")),
        cert: fs.readFileSync(config.get("ssl.certPath"))
      };
      server = https.createServer(options, app);
      server.listen(443);
      console.log("https");
    }
    else {
      server = http.createServer(app);
      server.listen(80);
    }

    server.on('upgrade', async function (req, socket, head) {
      console.log("Client IP:" + req.socket.remoteAddress);
      proxy.ws(req, socket, head, { target: 'ws://127.0.0.1:3200' });
    });
    process.on('uncaughtException', (error, origin) => {
      console.error('UNCAUGHT FATAL EXCEPTION:' + error.message);
      return;
    });
  }
})();