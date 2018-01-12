###################################################
# Joins the channels
###################################################
# parameters:
# $1 - name of the channel
# $2 - org on behalf of which the cannel will be created

CHANNEL=$1
ORG=$2

DOMAIN=$ORG
if [ "$DOMAIN" == "TraceLabel" ]; then
    DOMAIN=tracelabel
fi
echo "${msg_sub}-----> Joining channel '$CHANNEL' by '$ORG's peer0.${reset}"

#docker exec -e "CORE_PEER_LOCALMSPID=${ORG}MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@${DOMAIN,}.com/msp" peer0.${DOMAIN,}.com peer channel fetch config $CHANNEL.block -o $ORDERER -c $CHANNEL
POD=$(kubectl get pod -l org=${ORG,} | grep peer | gawk -e 'BEGIN { FS = " ";} { print $1; }')
kubectl exec $POD -i -- bash << END
CORE_PEER_LOCALMSPID=${ORG}MSP
CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/admin/msp
peer channel join -b $CHANNEL.block
END

