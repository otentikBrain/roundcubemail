#!/bin/bash

# The script is intended for use on Travis with Trusty distribution
# It executes unit and functional tests

DIR=$(dirname $0)
cd $DIR/..

if [ "$CODE_COVERAGE" = 1 ]
then
    CODE_COVERAGE_ARGS="--coverage-text"
fi

vendor/bin/phpunit -c tests/phpunit.xml $CODE_COVERAGE_ARGS

if [ "$BROWSER_TESTS" = 1 ] && [ $? = 0 ]
then
    .ci/setup.sh \
    && echo "TESTS_MODE: DESKTOP" \
    && TESTS_MODE=desktop vendor/bin/phpunit -c tests/Browser/phpunit.xml \
    && echo "TESTS_MODE: PHONE" \
    && TESTS_MODE=phone vendor/bin/phpunit -c tests/Browser/phpunit.xml \
    && echo "TESTS_MODE: TABLET" \
    && TESTS_MODE=tablet vendor/bin/phpunit -c tests/Browser/phpunit.xml
fi
