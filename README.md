basically runs your node and mongo init commands in nohup mode, meaning you can be in a single ssh session and run the server in the background instead of having the process consume your interface.
In addition to nohup, this current setup is logging to specific files in the /var/log directory.
If a command fails, it will determine by its exit code.
If node start fails, it will determine by checking the log for a 'listening' statement
If mongo start fails, it will look at the log for mongo in a similar way, based on keywords you can modify yourself etc.
Also has a server death script that will provide an epitaph, telling how long the server was up, and also providing a big dollop of superfluous fun for the whole family.

use in conjunction with bash aliases to really make server up and down a snap.

In your ~/.bash_aliases file
alias getup="/var/local/up.sh"
alias getdown="/var/local/down.sh"

replace getup and getdown with whatever commands you want server up and down to be
then run
source ~/.bashrc

Requirements:
- Bourne Again Shell (BASH UNIX/LINUX)
- nohup (sudo apt-get install nohup / yum install nohup / pacman...)
- This example requires node and mongo, but can change based on whatever you're trying to quicklaunch
- A pure heart
