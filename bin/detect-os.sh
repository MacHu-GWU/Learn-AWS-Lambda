#!/bin/bash
# -*- coding: utf-8 -*-


if [ "${OS}" = "Windows_NT" ]
then
    DETECTED_OS="Windows"
else
    DETECTED_OS=$(uname -s)
fi

if [ "${DETECTED_OS}" = "Windows" ]
then
    OS_IS_WINDOWS="Y"
    OS_IS_DARWIN="N"
    OS_IS_LINUX="N"
    OPEN_COMMAND="start"
elif [ "${DETECTED_OS}" = "Darwin" ]
then
    OS_IS_WINDOWS="N"
    OS_IS_DARWIN="Y"
    OS_IS_LINUX="N"
    OPEN_COMMAND="open"
elif [ "${DETECTED_OS}" = "Linux" ]
then
    OS_IS_WINDOWS="N"
    OS_IS_DARWIN="N"
    OS_IS_LINUX="Y"
    OPEN_COMMAND="open"
else
    OS_IS_WINDOWS="N"
    OS_IS_DARWIN="N"
    OS_IS_LINUX="N"
    OPEN_COMMAND="unknown_open_command"
fi
