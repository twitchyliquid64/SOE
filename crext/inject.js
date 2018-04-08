var trusted_origin = false;

function check_input_changed() {
  if (!trusted_origin)
    return;
  var i = document.getElementById('soe_assertion')
  if (!i)
    return; // if it disappeared.
  //console.log(i);
  if (i.value == '::!%soe_proceed') {
    i.value = '::!%soe_generating';
    generate_assertion(i);
  }
}

function generate_assertion(i) {
  chrome.runtime.sendMessage({command: "generate_assertion"}, function(response) {
    delete_soe_decisions(document.getElementById('soe_login_assertion_section'));
    i.value = response.assertion;
  });
}

function delete_soe_decisions(section) {
  if (section.hasAttribute('soe-login-enabled-hook') && document.getElementById('soe_assertion').value in ['::!%soe_ready', '::!%soe_proceed']) {
    document.getElementById('soe_assertion').value = '';
  }

  var i, s, sections = document.querySelectorAll('.soe-login-decision');
  for (i = 0; i < sections.length; i++) {
    section = sections[i];
    section.remove();
  }
}

function inject_soe_login_button(section) {
  delete_soe_decisions(section)

  if (section.hasAttribute('soe-login-enabled-hook')) {
    document.getElementById('soe_assertion').value = '::!%soe_ready';
  } else {
    var e = document.createElement('div');
    e.classList.add('soe-login-decision');
    var s = document.createElement('a');
    s.classList.add('soe-generate-button');
    s.innerText = 'Generate SOE assertion';
    s.setAttribute('style', 'cursor: pointer;')
    var clicked = false;
    s.addEventListener('click', function(){
      if (clicked)return;
      clicked = true;
      s.innerText = 'Generating...';
      generate_assertion(document.getElementById('soe_assertion'));
    })
    e.appendChild(s);
    section.appendChild(e);
  }
}

function inject_soe_denied_info(section) {
  delete_soe_decisions(section);

  if (section.hasAttribute('soe-login-disabled-hook')) {
    document.getElementById('soe_assertion').value = '::!%soe_denied';
  } else {
    var e = document.createElement('div');
    e.classList.add('soe-login-decision');
    var s = document.createElement('span');
    s.innerText = 'SOE login not supported as this domain is not a trusted origin.';
    e.appendChild(s);
    section.appendChild(e);
  }
}

function init_soe_inject() {
  var section = document.getElementById('soe_login_assertion_section');
  if (section) {
    chrome.runtime.sendMessage({command: "permitted_origin"}, function(response) {
      trusted_origin = response.allowed;
      if (trusted_origin) {
        inject_soe_login_button(section);
      } else {
        inject_soe_denied_info(section);
      }
    });
  }

  setInterval(check_input_changed, 750);
}

var readyStateCheckInterval = setInterval(function() {
	if (document.readyState === "complete") {
			clearInterval(readyStateCheckInterval);
			init_soe_inject();
	}
}, 70);


chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if (sender.id != chrome.runtime.id) {
      console.log('Got message from untrusted, BAIL!');
      console.log("Sender:", sender);
      return;
    }

    switch(request.command) {
      case 'update_permitted_origin':
        trusted_origin = request.allowed;
        var section = document.getElementById('soe_login_assertion_section');
        if (section) {
          if (trusted_origin) {
            inject_soe_login_button(section);
          } else {
            inject_soe_denied_info(section);
          }
        }
        return;
    }
});
