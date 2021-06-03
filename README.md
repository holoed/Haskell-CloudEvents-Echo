# Haskell-CloudEvents-Echo
Haskell Implementation of a Knative Microservice that echos Cloud Events

kn service create cloud-events-echo --image docker.io/user/cloud-events-echo

kn trigger create myTrigger --broker default --sink ksvc:cloud-events-echo
