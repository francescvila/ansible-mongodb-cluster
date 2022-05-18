#!/bin/bash
set -e
mongo <<EOF
use admin
db.createUser({
  user: "root",
  pwd: "$MONGO_INITDB_ROOT_PASSWORD",
  roles: [{
    role: "root",
    db: "admin"
  }]
});
db.auth("root", "$MONGO_INITDB_ROOT_PASSWORD");
db.createUser({
  user: "$MONGO_INITDB_ROOT_USERNAME",
  pwd: "$MONGO_INITDB_ROOT_PASSWORD",
  roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase","readWriteAnyDatabase"]
});
use $MONGO_INITDB_DATABASE;
db.createUser({
  user: "$MONGO_INITDB_APP_USERNAME",
  pwd: "$MONGO_INITDB_APP_PASSWORD",
  roles: [{
    role: "readWrite",
    db: "$MONGO_INITDB_APP_DATABASE"
  }]
});
EOF
