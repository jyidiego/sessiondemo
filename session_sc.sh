#!/bin/bash

# run this file with the command:
# sh session_sc.sh > runme.sh
# and then run:
# ./runme.sh
#

export AS_URL=$(keystone catalog --service rax:autoscale 2> /dev/null | grep publicURL | grep $OS_REGION_NAME_LOWER | cut -d ' ' -f4)

cat <<EOF
curl -i ${AS_URL}/groups -X POST  -k \
    -H 'X-Auth-Project-Id: ${HEAT_TENANT_ID}' \
    -H 'User-Agent: pyrax/1.7.0' \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -H 'X-Auth-Token: ${OS_TOKEN}' -d '
{
    "groupConfiguration": {
        "cooldown": 120,
        "maxEntities": 4,
        "metadata": {},
        "minEntities": 1,
        "name": "sessionDemoAutoScale"
    },
    "launchConfiguration": {
        "args": {
            "loadBalancers" : [{ 
                "loadBalancerId" : 363877,
                "port" : 8080
            }],
            "server": {
                "OS-DCF:diskConfig" : "MANUAL",
                "config_drive" : true,
                "flavorRef": "performance1-1",
                "networks": [
                {
                   "uuid": "11111111-1111-1111-1111-111111111111"
                },
                {
                   "uuid": "00000000-0000-0000-0000-000000000000"
                },
                {
                   "uuid": "65e712db-0616-4d71-926c-47b8e8f2dfeb"
                }
                ],
                "imageRef": "598a4282-f14b-4e50-af4c-b3e52749d9f9",
                "key_name" : "ansible_demo",
                "user_data" : "I2Nsb3VkLWNvbmZpZwoKcGFja2FnZV91cGdyYWRlOiB0cnVlCgpwYWNrYWdlczoKICAtIHB5dGhvbi1waXAKICAtIHB5dGhvbi1kZXYKICAtIGRvY2tlci5pbwoKcnVuY21kOgogIC0gcGlwIGluc3RhbGwgbmV0aWZhY2VzCiAgLSBzeXNjdGwgbmV0LmlwdjQuaWNtcF9lY2hvX2lnbm9yZV9icm9hZGNhc3RzPTAKICAtIGlwIHJvdXRlIGFkZCAyMjQuMC4wLjAvNCBkZXYgZXRoMgogIC0gZ2l0IGNsb25lIGh0dHBzOi8vZ2l0aHViLmNvbS9qeWlkaWVnby9zZXNzaW9uZGVtby5naXQgL3Jvb3Qvc2Vzc2lvbmRlbW8KICAtIC9yb290L3Nlc3Npb25kZW1vL3NlcnZlcl94bWwuc2ggJCgvcm9vdC9zZXNzaW9uZGVtby9nZW5fc2VydmVyX3htbC5weSBldGgyKSA+IC9yb290L3NlcnZlci54bWwKICAtIGRvY2tlciBydW4gLWQgLXYgL3Jvb3Q6L21udCAtLW5ldD1ob3N0IGp5aWRpZWdvL3Nlc3Npb25kZW1vIC4vcnVuLnNoCg==",
                "name": "sessionDemo"
            }
        },
        "type": "launch_server"
    },
    "scalingPolicies": []
}'
EOF
