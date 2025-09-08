#!/bin/bash

# Check if docsify-cli is installed
if ! command -v docsify &> /dev/null; then
    echo "docsify-cli is not installed. Installing now..."
    npm install -g docsify-cli
fi

# Start the docsify server
echo "Starting docsify server..."
docsify serve . 