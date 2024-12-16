### What does it do?

Makes RP5 fan silent on idle load and quite on medium load

### Is it safe to use?

When script quits it brings fan mode back to "factory" settings.

## Usage
``` 
sudo apt-get install git
git clone https://github.com/Luxvao/rp5-fan-control
cd rp5-fan-control
chmod +x rp5-fan-control.sh
sudo ./rp5-fan-control.sh
```
## Installation

To make it start when system boots:

edit rp5-fan-controller and add the path of the rp5-fan-control.sh script (full-pathname), then do the following to add it
to the runlevels

    cd /etc/init.d/
    #adjust to correct, absolute path below
    sudo ln -s ~/rp5-fan-control /etc/init.d/retroid-fan-controller
    sudo update-rc.d retroid-fan-controller defaults

you can also use the following to start the controller

    sudo /etc/init.d/rp5-fan-controller start

or

    sudo /etc/init.d/rp5-fan-controller stop

to stop the controller
