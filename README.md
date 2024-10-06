## needs_restart.pl  
This script just compares the checksum of running containers against the latest pulled image.
It doesn't connect to dockerhub or anything like that.
You could do docker compose pull on a schedule and this script would alert you to any containers that are due a restart.  

Usage: perl needs_restart.pl
