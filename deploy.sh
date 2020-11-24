#!/bin/sh
TAG=`date "+%Y-%m-%d-%H-%M"`
QENV="dev"
PROJECT_ID="my-project"
GKE_CLUSTER="cluster"
GKE_ZONE="asia-east2-a"
DEPLOYMENT_NAME="dev-name"
IMAGE="my-image"

echo "========================================"
echo "Shell Script: Start"
echo "========================================"
echo "TAG:              $TAG"
echo "QENV:             $QENV"
echo "PROJECT_ID:       $PROJECT_ID"
echo "GKE_CLUSTER:      $GKE_CLUSTER"
echo "GKE_ZONE:         $GKE_ZONE"
echo "DEPLOYMENT_NAME:  $DEPLOYMENT_NAME"
echo "IMAGE:            $IMAGE"
echo "========================================"

echo "1. docker build"
docker build -t gcr.io/$PROJECT_ID/$IMAGE:$TAG --build-arg QENV=$QENV .

echo "2. push docker image"
docker push gcr.io/$PROJECT_ID/$IMAGE:$TAG

echo "3. reflash pod"
kubectl config use-context gke_${PROJECT_ID}_${GKE_ZONE}_${GKE_CLUSTER}
kubectl set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=gcr.io/$PROJECT_ID/$IMAGE:$TAG

echo "Done."
