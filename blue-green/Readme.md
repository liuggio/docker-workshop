Vogliamo un tool che effettui

il build dell'altro colore 
una volta deployato, venga testato con un wget
e poi che faccia lo swap nel load balancer

docker-compose \
   -f docker-compose.yml -f docker-compose.prod.yml
   up 
   

