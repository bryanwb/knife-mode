= commands

All commands assume that you started emacs from a path where knife can
find .chef/knife.rb. This mode does not preload knife.rb

* knife-cookbook-test

Saves all buffers, then runs `knife cookbook test ` on the current cookbook

* knife-cookbook-foodcritic

Saves all buffers, then runs `foodcritic ` on the current cookbook

* knife-from-file 

Depending on the current buffer, saves all buffers, determines,
whether the current buffer is a role, cookbook, environment, data_bag,
and then invokes the proper command to upload it to your chef server

= installation

Put knife.el in a path where emacs can find it

Add the following to your .emacs file

(require 'knife)


= Copyright

Bryan W. Berry (<bryan.berry@gmail.com>)
Apache v2.0 license