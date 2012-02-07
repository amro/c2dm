# c2dm

c2dm sends push notifications to Android devices via google [c2dm](http://code.google.com/android/c2dm/index.html).

##Installation

    $ gem install c2dm
    
##Requirements

An Android device running 2.2 or newer, its registration token, and a google account registered for c2dm.

##Usage

There are two ways to use c2dm.

Sending many notifications:
	notifications = [
	  {
	    :registration_id => "...", 
	    :data => {
	      :some_message => "Some payload"
	      :another_message => 10
	    },
	    :collapse_key => "foobar" #optional
	  }
	]
	
	C2DM.authenticate!("your@googleuser.com", "somepassword", "YourCo-App-1.0.0")
	C2DM.send_notifications(notifications)

...or one at a time:
	C2DM.authenticate!("your@googleuser.com", "somepassword", "YourCo-App-1.0.0")
	c2dm = C2DM.new

	notification = {
	  :registration_id => "...", 
	  :data => {
	    :some_message => "Some payload",
	    :another_message => 10
	  },
	  :collapse_key => "foobar" #optional
	}

	c2dm.send_notification(notification)

Note that calling *authenticate!* will authenticate all new instances of C2DM. You can override this by passing in your own auth_token:
	c2dm = C2DM.new(auth_token)

##Copyrights

* Copyright (c) 2010-2012 Amro Mousa, Shawn Veader. See LICENSE.txt for details.

##Thanks

* [Paul Chun](https://github.com/sixofhearts)
* [gowalla](https://github.com/gowalla)

##Other stuff

You might want to checkout GroupMe's fork of this gem as well.