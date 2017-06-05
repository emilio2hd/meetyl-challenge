# meetyl-challenge

# Getting started

Before start the application, execute:
```
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

Now, you can run the application ;)

# Docker & Docker Compose
To start the application using docker, execute:
```
docker-compose up -d
docker exec -it meetyl-api bash -lc "bundle exec rake db:seed"
```

# API Documentation
The documentation can be found at **doc** folder, or running the application and browsing http://0.0.0.0:9292

To generate the documentation, execute on terminal:
```
rake apipie:static
```