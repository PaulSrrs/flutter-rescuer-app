#!/bin/bash
cd ../
flutter test --coverage
lcov --remove coverage/lcov.info 'lib/client/*' 'lib/blocs/connectivity.bloc.dart' 'lib/main.dart' 'lib/pages/*' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info --output=coverage
open coverage/index.html