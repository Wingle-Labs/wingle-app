#!/bin/bash

dart run build_runner clean
dart run build_runner build
dart run build_runner watch --delete-conflicting-outputs