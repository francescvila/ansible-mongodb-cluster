#!/bin/bash
set -e
mongo <<EOF
use admin
db.auth("root", "$MONGO_INITDB_ROOT_PASSWORD");
cfg = {
          _id: "$MONGO_REPLICASET_NAME",
          version: 1,
          members: [
              { _id: 0, host: "$MONGO_HOST_NODE1:27017" },
              { _id: 1, host: "$MONGO_HOST_NODE2:27017" },
              { _id: 2, host: "$MONGO_HOST_NODE3:27017" }
          ]
      };
rs.reconfig(cfg);
EOF
