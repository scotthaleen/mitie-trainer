#!/bin/sh

sleep 5
curl --silent --fail localhost:8000 || exit 1
