#!/bin/bash

bbuild src/gdiff
mkdir -p test/
mv gdiff.tgz test/

echo "Move output to test/"
