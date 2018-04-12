// Allowed origin storage
var allowed_origins = {};
function save_settings() {
  var settings = {
    'allowed_origins': allowed_origins,
  };
  chrome.storage.sync.set(settings, function() {
    console.log("Saved settings.")
  });
}
function load_settings(){
  chrome.storage.sync.get(['allowed_origins'], function(data){
    allowed_origins = data['allowed_origins'] || {};
    console.log("Settings loaded:", data);
  })
}
function handleStorageChanged(changes, namespace) {
  if (namespace == 'sync'){
    for (key in changes) {
      console.log("Data change to: " + key);
      var storageChange = changes[key];
      if (key == 'allowed_origins'){
        allowed_origins = storageChange.newValue;
      }
    }
  }
}

function sendNative(msg_obj) {
  var port = chrome.runtime.connectNative('com.soe.native');
  port.onMessage.addListener(function(msg) {
    console.log("Received" + msg);
  });
  port.onDisconnect.addListener(function() {
    console.log("Disconnected");
  });
  port.postMessage(msg_obj);
}

function extractOrigin(url) {
    schemeIndex = url.indexOf("://");
    if (schemeIndex > -1) {
        return url.substring(0, schemeIndex) + "://" + url.substring(schemeIndex + "://".length).split('/')[0];
    }
    return url.split('/')[0];
}

// Popup / content script API
function handleMsg(request, sender, sendResponse) {
  if (sender.id != chrome.runtime.id) {
    console.log('Got message from untrusted, BAIL!');
    console.log("Sender:", sender);
    return;
  }
  console.log('Handling: ', request, 'from', sender);

  switch (request.command) {
    case 'permitted_origin':
      var o = extractOrigin(sender.url);
      sendResponse({allowed: o in allowed_origins});
      return;

    case 'trust_current_origin':
      chrome.tabs.getSelected(null, function(tab) {
          allowed_origins[extractOrigin(tab.url)] = {timestamp: new Date()};
          save_settings();
          chrome.tabs.sendMessage(tab.id, {command: "update_permitted_origin", allowed: true});
      });
      sendResponse({});
      return;

    case 'delete_origin':
      delete allowed_origins[request.origin];
      save_settings();
      sendResponse({});
      chrome.tabs.query({}, function(tabs) {
        for (var i = 0; i < tabs.length; i++) {
          if (extractOrigin(tabs[i].url) == request.origin) {
            chrome.tabs.sendMessage(tabs[i].id, {command: "update_permitted_origin", allowed: false});
          }
        }
      });
      return;

    case 'get_permitted_origins':
      sendResponse({origins: allowed_origins});
      return;
  }

  sendResponse({});
}


// Register hooks.
chrome.runtime.onMessage.addListener(handleMsg);
chrome.storage.onChanged.addListener(handleStorageChanged);
load_settings();
