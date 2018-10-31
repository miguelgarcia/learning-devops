#!/bin/bash

set -e 

echo "Configuring wordpress deployment"

source ../k8s-aws-cluster/config.sh
source .wordpress_uploads_fs

cat <<EOF > config/wordpress.yml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: wordpress-deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:4-php7.0
        # uncomment to fix perm issue, see also https://github.com/kubernetes/kubernetes/issues/2630
        command: ['bash', '-c', 'mkdir -p /var/www/html/wp-content/uploads; chown www-data:www-data /var/www/html/wp-content/uploads && docker-entrypoint.sh apache2-foreground']
        ports:
        - name: http-port
          containerPort: 80
        env:
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: db-password
          - name: WORDPRESS_AUTH_KEY
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: authkey
          - name: WORDPRESS_LOGGED_IN_KEY
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: loggedinkey
          - name: WORDPRESS_SECURE_AUTH_KEY
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: secureauthkey
          - name: WORDPRESS_NONCE_KEY
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: noncekey
          - name: WORDPRESS_AUTH_SALT
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: authsalt
          - name: WORDPRESS_SECURE_AUTH_SALT
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: secureauthsalt
          - name: WORDPRESS_LOGGED_IN_SALT
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: loggedinsalt
          - name: WORDPRESS_NONCE_SALT
            valueFrom:
              secretKeyRef:
                name: wp-secrets
                key: noncesalt
          - name: WORDPRESS_DB_HOST
            value: db
        volumeMounts:
          - mountPath: /var/www/html/wp-content/uploads
            name: uploads
      volumes:
      - name: uploads
        nfs:
          server: ${AWS_ZONES}.${UPLOADS_FILE_SYSTEM_ID}.efs.${AWS_REGION}.amazonaws.com
          path: /
---
apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  ports:
  - port: 80
    targetPort: http-port
    protocol: TCP
  selector:
    app: wordpress
  type: LoadBalancer

EOF

echo "Wordpress deployment configured"