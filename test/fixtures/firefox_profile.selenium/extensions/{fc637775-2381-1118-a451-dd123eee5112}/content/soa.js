//navigator.online: Not updated fast enough



var soaObsvr = {
  observe: function(aSubject, aTopic, aData) {
	    if(aTopic != "network:offline-status-changed") 
			return;
		if(aData == "online" || soa.isUserAction)
			return;
		soa.setOnline();
  },
};









var soa = {
	gPrefService: Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch),
	ioService: Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService2),
	observerSrv: Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService),
	consoleService: Components.classes["@mozilla.org/consoleservice;1"].getService(Components.interfaces.nsIConsoleService),
	isUserAction: false,

		LOG: function(text)
		{
		    soa.consoleService.logStringMessage(text);
		},


		init: function(event)
		{
			soa.setOnline(); //on start set online in any case

			soa.observerSrv.addObserver(soaObsvr, "network:offline-status-changed", false);//observer

			if(document.getElementById("goOfflineMenuitem")) //detect when user switches to offline
				document.getElementById("goOfflineMenuitem").addEventListener("mouseup", function (event){soa.isUserAction = true;}, false);
		},


		setOnline: function()
		{
			try{
				soa.gPrefService.clearUserPref("browser.offline"); //set preference to online
			}catch(e){}

			try{ //stop automatic management of the offline status, nothing more should be needed
			  soa.ioService.manageOfflineStatus = false; 
			}catch(e){}

			if(!soa.ioService.offline)
				return;
			soa.ioService.offline = false; //set service to online
			navigator.preference("toolkit.networkmanager.disable", true);
			soa.LOG("StayOnline prevents Firefox from going offline.");
		},




		OptionsLoad: function()
		{
		},


		OptionsClose: function()
		{
		},


};