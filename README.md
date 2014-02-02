Simple Message System
=====================

Please note that this repository is not being actively maintained.

![message](https://f.cloud.github.com/assets/1284703/2059827/fb5c504a-8bd8-11e3-953d-aa4c0395055e.png)

---

NGINX config:

    upstream app_server {
        server unix:/tmp/unicorn.sock fail_timeout=0;
    }
    server {
        client_max_body_size 1m;
        server_name <SERVER>;
        keepalive_timeout 5;
        root /srv/qnn/message/public;
        try_files $uri/index.html $uri.html $uri @app;
        location @app {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass http://app_server;
        }
        error_page 500 502 503 504 /500.html;
        location = /500.html {
            root /srv/qnn/message/public;
        }
    }

Deploy:

    cd /srv/qnn
    git clone https://github.com/qnn/message.git
    export RAILS_ENV=production
    bundle exec rake db:migrate
    bundle exec rake db:seed
    bundle exec rake assets:precompile
    start_unicorn

Reference: [Running Multiple Rails Apps on Nginx](https://github.com/Hack56/Rails-Template/wiki/Running-Multiple-Rails-Apps-on-Nginx)
