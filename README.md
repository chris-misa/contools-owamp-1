# Contools OWAMP Experiment 1

Using a basic two node, one link topology, runs
all four possible test permutations.

The node named 'host' is in general the instigator and the node
named 'target' is in general the runner of daemons.


owamp'ing around docker's NAT is a pain:

http://linlog.blogspot.com/2009/06/owamp-problems-behind-nat.html
	. . . use authenticated mode (-A A + passphrases)
http://linlog.blogspot.com/2009/06/more-problems-with-owamp-behind-nat.html
  . . . use -x to tell client it's public-facing ip
  . . . use -N on server to keep it from trying to bind on public side of NAT

Maybe we need to reconsider the networking mode here?
