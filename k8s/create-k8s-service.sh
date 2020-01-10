#!/usr/bin/env bash
set -euo pipefail

function usage {
    local message
    [ "$#" -gt 0 ] || message="\n$1"
    cat <<HERE
usage: $0 <appid>

appid: the app id required for accessing https://openweathermap.org/api$message
HERE
}

function main {

    if [ "$#" -ne 1 ]; then
        usage "APPID not provided!"
        exit 1
    fi

    if [ -z "$1" ]; then
        usage "APPID not provided!"
        exit 1
    fi

    export APPID="$1"

    [ ! -d "build" ] && mkdir build
    LOG_FILE="build/create_k8s_service.log"
    set +e
    kubectl get deployment weather-service-node > $LOG_FILE 2>&1
    result=$?
    set -e
    if [ $result -ne 0 ]; then
        echo "Creating deployment..."
        (envsubst < weather-service-deployment.yaml | kubectl create -f -) > $LOG_FILE 2>&1
    fi

    set +e
    kubectl get service weather-service > $LOG_FILE 2>&1
    result=$?
    set -e
    if [ $result -ne 0 ]; then
        echo "Creating service..."
        kubectl create -f weather-service.yaml > $LOG_FILE 2>&1
    fi
                                                                
    set +e                                                     
    kubectl get ingress weather-service-ingress > $LOG_FILE 2>&1       
    result=$?                                                  
    set -e                                                     
    if [ $result -ne 0 ]; then                                 
        echo "Creating ingress..."                             
        kubectl create -f weather-service-ingress.yaml > $LOG_FILE 2>&1
    fi                                                         

    echo "waiting for pods to become ready..."
    kubectl wait --for=condition=Ready pod --all

}

main "$@"
