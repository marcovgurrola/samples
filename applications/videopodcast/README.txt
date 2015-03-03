This folder contains the videopodcast deployment on Bitnami MAMP (Mac Machine),
should be a similar configuration for another stack,
assuming the apache http port is 8080, just change the port number for the
following settings if your server’s port differs.

https://bitnami.com/stack/mamp

VIDEOPODCAST APP

1. localhost

This structure allows you create your own application that  will be accessible at
http://localhost:8080/videopodcast

- You should copy the “videopodcast” folder into the
 /Applications/mampstack-5.4.34-0/apps folder

- Add the following line at the end of the
/Applications/mampstack-5.4.34-0/apache2/conf/bitnami/bitnami-apps-prefix.conf file

Include "/Applications/mampstack-5.4.34-0/apps/videopodcast/conf/httpd-prefix.conf"

Then restart the Apache server. You can use the graphical Manager tool 
that you can find in your installation directory.

Go to your browser at
 http://localhost:8080/videopodcast
 and you will see the Home page.


2. VIRTUAL HOST

The videopodcast app can also be configured in a Virtual Host. In this case
you can run your application at
 http://videopodcast.com or any custom domain.

To enable Virtual Host configuration, you only
 have to disable the previous configuration in the
 "/Applications/mampstack-5.4.34-0/apache2/conf/bitnami/bitnami-apps-prefix.conf" file

#Include "/Applications/mampstack-5.4.34-0/apps/videopodcast/conf/httpd-prefix.conf" 

and enable the new Virtual Host configuration file in the
 
"/Applications/mampstack-5.4.34-0/apache2/conf/bitnami/bitnami-apps-vhosts.conf" file:

Include "/Applications/mampstack-5.4.34-0/apps/videopodcast/conf/httpd-vhosts.conf"

Then restart Apache server and try to access at http://videopodcast.com


IMPORTANT: Virtual Host configuration requires that the domain name points to the
server IP address. If you are testing this configuration, you can add a new entry
in the "hosts" file in your system.


3 CONTROLS
These are the keys for controlling the channels and videos selection, and playback as well:
Keyboard Keys
Play/Pause: Enter
Volume: + -
Seek Rev/Fwd: Left/Right Arrow
Toggle Controls: Space Bar
Channels: 1-9

