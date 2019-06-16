const WebSocket = require('ws');

/* Server methods */
exports.createWebSocketServer_ = function (options, callback) {
  return new WebSocket.Server(options, callback);
}

exports.onConnection_ = function(wss, handleConnection) {
  wss.on('connection', handleConnection);
}

exports.onServerError_ = function(wss, handleError) {
  wss.on('error', handleError);
}

/* WebSocket methods */
exports.onMessage_ = function(ws, handleMessage) {
  ws.on('message', handleMessage);
}

exports.onClose_ = function(ws, handleClose) {
  ws.on('close', handleClose);
}

exports.onError_ = function(ws, handleError) {
  ws.on('error', handleError);
}

exports.sendMessage_ = function(ws, message) {
  ws.send(message);
}

exports.close_ = function(ws, code, reason) {
  ws.close(code, reason);
}
