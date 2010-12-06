# c2dm

c2dm sends push notifications to Android devices via google [c2dm](http://code.google.com/android/c2dm/index.html).

##Installation

    $ gem install c2dm
    
##Requirements

An Android device running 2.2 or newer, its registration token, and a google account registered for c2dm.

##Usage

There are two ways to use c2dm.

Sending an array of notifications:

    notifications = [{:registration_id => registration_id2_from_client, :message => "Some awesome message"}]
    C2DM::Push.send_notifications(your_google_account_id, your_password, "MyCompany-MyApp-1.0", notifications)

or one at a time:

    c2dm = C2DM::Push.new(your_google_account_id, your_password, "MyCompany-MyApp-1.0")
    c2dm.send_notification(registration_id2_from_client, "Some awesome message")

##Copyrights

* Copyright (c) 2010 Amro Mousa. See LICENSE.txt for details.