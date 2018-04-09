var origins = {};

function create_origin_tr(origin, origin_data) {
  var e = document.createElement('tr');
  var domain = document.createElement('td');
  domain.innerText = origin;
  e.appendChild(domain);

  var actions = document.createElement('td');
  var del_btn = document.createElement('a');
  del_btn.classList.add('btn');
  del_btn.classList.add('btn-default');
  del_btn.innerText = 'Delete';
  del_btn.addEventListener('click', function(){
    console.log('Got delete for ', origin);
    chrome.runtime.sendMessage({command: "delete_origin", origin: origin}, function(response) {
      update_domains_list();
    });
  });
  actions.appendChild(del_btn);
  e.appendChild(actions);
  return e;
}

function generate_domains_table() {
  var tbody = document.getElementById('trusted_origins_tbody');

  // delete all elements
  while (tbody.firstChild) {
    tbody.removeChild(tbody.firstChild);
  }

  for (const origin in origins) {
    if (origins.hasOwnProperty(origin)) {
      var e = create_origin_tr(origin, origins[origin]);
      tbody.appendChild(e);
    }
  }
}

function trust_current_origin() {
  chrome.runtime.sendMessage({command: "trust_current_origin"}, function(response) {
    setTimeout(update_domains_list, 100);
  });
}

function update_domains_list() {
  chrome.runtime.sendMessage({command: "get_permitted_origins"}, function(response) {
    origins = response.origins;
    generate_domains_table();
  });
}

function init_soe_popup() {
  update_domains_list();

  document.getElementById('trust_current_origin_btn').addEventListener(
    'click', trust_current_origin);

  document.getElementById('config_tab').addEventListener('click', function(){
    $("#trusted_origins").show();
    $("#shortcuts").hide();
    document.getElementById('config_tab').classList.add('active');
    document.getElementById('shortcut_tab').classList.remove('active');
  });
  document.getElementById('shortcut_tab').addEventListener('click', function(){
    $("#trusted_origins").hide();
    $("#shortcuts").show();
    document.getElementById('shortcut_tab').classList.add('active');
    document.getElementById('config_tab').classList.remove('active');
  });
};

var readyStateCheckInterval = setInterval(function() {
	if (document.readyState === "complete") {
			clearInterval(readyStateCheckInterval);
			init_soe_popup();
	}
}, 70);
