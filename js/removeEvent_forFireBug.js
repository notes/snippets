function removeEventHandler(node, event) {
  var listeners = getEventListeners(node)[event];
  if (!listeners) return;
  for (var i=0; i < listeners.length; i++) {
    node.removeEventListener(event, listeners[i].listener);
  }
}

function removeAllEventHandlers(node) {
  var allListeners = getEventListeners(node);
  for (var eventName in allListeners) {
    var listeners = allListeners[eventName];
    for (var i=0; i < listeners.length; i++) {
      node.removeEventListener(eventName, listeners[i].listener);
    }
  }
}
