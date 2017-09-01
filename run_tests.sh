#! /bin/sh

docker-compose up -d
printf '\nwaiting for validation services to boot'; 

TRIES=0

until $(curl --output /dev/null --silent --head --fail http://0.0.0.0:4567) || [ $TRIES -eq 15 ]; do  
  (( TRIES++ ))
  printf '.'; 
  sleep 1;
done

if [ $TRIES -eq 15 ]; then
  printf '\nno response from server'
else
  printf '\nrunning tests\n'
  docker-compose run --rm app ruby tests/irish_business_rules_tests.rb $@
fi

printf '\ndone! stopping services\n'; 

docker-compose down