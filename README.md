Demo script can be found at:
https://www.notion.so/CD-as-a-Service-Demo-Script-348cbe030894448b9eee3774c17c2521

To set this demo up on your kubernetes environment:
1) setup a cloud console environment
2) got to the 'client credentials' screen, and create a new set of agent credentials.
3) authenticate against your kubernetes cluster, and set your context to be on it. The next step is going to install a bunch of agents on it.
4) cd into `./configuration` and run `./setup.sh <clientID> <clientSecret>` where clientID and clientSecret are the credentials from step 2.

_The current `setup.sh` script has some local pathing issues and will fail if run outside of the `./configuration` directory._
