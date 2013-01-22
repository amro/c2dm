# c2dm

c2dm sends push notifications to Android devices via c2dm sends push notifications to Android devices via [Google Cloud Messaging (GCM)](http://code.google.com/android/c2dm/index.html).

##Installation

    $ gem install c2dm
    
##Requirements

An Android device running 2.2 or newer, its registration token, and a [GCM api key](https://code.google.com/apis/console).

##Usage

There are two ways to use c2dm.

Sending many individual notifications using a static method:

	notifications = [
	  {
	    registration_id: "...1", 
	    data: {
	      some_message: "Some payload",
	      a_value: 10
	    },
	    collapse_key: "foobar" #optional
    },
	  {
	    registration_id: "...2", 
	    data: {
	      some_message: "Some other payload",
	      a_value: 20
	    }
	  }
	]
	
	C2DM.api_key = "YourGCMApiKey" # This initializes all future instances of C2DM with "YourGCMApiKey"
	C2DM.send_notifications(notifications)

Sending this way will not raise an error but `send_notifications` will return an array of 
hashes including the `registration_id` and the `response`. If GCM returns an error while C2DM
is sending one of the notifications, the response will be an object of type `C2DM::GCMError`.

...or one at a time by creating an instance:

	c2dm = C2DM.new("YourGCMApiKey")

  data = {
    some_message: "Some payload",
    another_message: 10
  }
  
	collapse_key = "optional_collapse_key"

	c2dm.send_notification("aRegistrationId", data, collapse_key)
  
Sending using an instance of C2DM will raise a `C2DM::GCMError` error when sending fails.

##Copyrights

* Copyright (c) 2010-2012 Amro Mousa. See LICENSE.txt for details.

##Thanks
* [Shawn Veader](https://github.com/veader)
* [Paul Chun](https://github.com/sixofhearts)
* [gowalla](https://github.com/gowalla)