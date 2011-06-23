# c2dm

c2dm sends push notifications to Android devices via google [c2dm](http://code.google.com/android/c2dm/index.html).

##Installation

    $ gem install c2dm
    
##Requirements

An Android device running 2.2 or newer, its registration token, and a google account registered for c2dm.

##Usage

There are two ways to use c2dm.

Sending many notifications:
```notifications = [
  {
    :registration_id => "...", 
    :data => {
      :some_message => "Some payload"
      :another_message => 10
    },
    :collapse_key => "foobar" #optional
  }
]

C2DM.send_notifications("someone@gmail.com", "and_their_password", notifications, "MyCompany-MyApp-1.0.0")```

...or one at a time:
```c2dm = C2DM.new("someone@gmail.com", "and_their_password", "MyCompany-MyApp-1.0")

notification = {
  :registration_id => "...", 
  :data => {
    :some_message => "Some payload",
    :another_message => 10
  },
  :collapse_key => "foobar" #optional
}

c2dm.send_notification(notification)```

##Copyrights

* Copyright (c) 2010-2011 Amro Mousa, Shawn Veader. See LICENSE.txt for details.

##Thanks

* [Paul Chun](https://github.com/sixofhearts)

##Other stuff

You might want to checkout GroupMe's fork of this gem as well.