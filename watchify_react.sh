#!/bin/bash

watchify -t [ babelify --presets [ react ] ] server/public/js/main.js -o server/public/js/bundle.js
