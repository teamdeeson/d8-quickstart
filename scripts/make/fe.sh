#!/bin/bash

set -e

# Build the frontend.
cd src/frontend
yarn
yarn build
cd ../../
