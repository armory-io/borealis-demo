cd reset
#armory deploy start -f deploy1.yml
#sleep 60
#armory deploy start -f deploy2.yml
#sleep 60
#kubectl -n=borealis delete rs --all
#kubectl -n=borealis-staging delete rs --all
#kubectl -n=borealis-infosec delete rs --all
#kubectl -n=borealis-dev delete rs --all
#kubectl -n=borealis-prod delete rs --all
#kubectl -n=borealis-prod2 delete rs --all
#sleep 60
armory deploy start -f deploy3.yml -w


