#!/bin/sh

# ==================================================
JAVA_HOME="../jdks/18/linux-x64"
JAVA="${JAVA_HOME}/bin/java"
JPS="${JAVA_HOME}/bin/jps"
LOCK_FILE="MCPA.lock"
APP_NAME="MCPA.jar"
CONFIG_NAME="CPA_MMS.conf"
# ==================================================
APP_STATUS=""
PID=""
ARG=""

# check JDK
if [ ! -d ${JAVA_HOME} ]; then
  if [ -f "../jdks/jdk18-linux-x64.tar.gz" ]; then
    echo "tar xvf ../jdks/jdk18-linux-x64.tar.gz -C ../jdks"
    tar xfz ../jdks/jdk18-linux-x64.tar.gz -C ../jdks
  else
    echo "not found JAVA_HOME and jdk18-linux-x64.tar.gz file"
    exit
  fi
fi

help() {
    echo "usage: $0 help"
    echo "       $0 (start|stop|restart|status)"

    cat <<EOF

        help       - this screen
        start      - start MMS-MO service
        stop       - stop  MMS-MO service
        restart    - restart or start MMS-MO service
        status     - show the status of MMS-MO service

EOF
}

is_running() {
    PID=$(${JPS} -l | grep "${APP_NAME}" | awk '{print $1}')
    if [ -z "${PID}" ]; then
        APP_STATUS="${APP_NAME} is not running"
        return 0
    else
        APP_STATUS="${APP_NAME} already running. (pid: ${PID})"
        return 1
    fi
}

start_app() {
    is_running
    RUNNING=$?
    if [ ${RUNNING} -eq 1 ]; then
        echo "$0 ${ARG} : (pid ${PID}) ${APP_STATUS}"
        exit
    fi

    if [ -f "${LOCK_FILE}" ]; then
        echo "delete lock file: ${LOCK_FILE}"
        rm -f "${LOCK_FILE}"
    fi

    ${JAVA} \
    -Xms32m \
    -Xmx64m -XX:+UseG1GC \
    -XX:MetaspaceSize=32M \
    -XX:MaxMetaspaceSize=64M \
    -Djdk.nio.maxCachedBufferSize=10485760 \
    -jar "${APP_NAME}" "${CONFIG_NAME}" > /dev/null &

    echo "Wait 10 seconds to make sure it's working well"
    sleep 10

    is_running
    RUNNING=$?
    if [ ${RUNNING} -eq 1 ]; then
        echo "$0 ${ARG} : ${APP_NAME}  started"
    else
        echo "$0 ${ARG} : ${APP_NAME}  could not be started"
    fi
    return ${RUNNING}
}

stop_app() {
    is_running
    RUNNING=$?
    if [ ${RUNNING} -eq 0 ]; then
        echo "$0 ${ARG} : ${APP_STATUS}"
        exit
    fi

    kill ${PID}

    sleep 2

    is_running
    RUNNING=$?
    if [ ${RUNNING} -eq 0 ]; then
        echo "$0 ${ARG}: ${APP_NAME}  stopped"
    else
        echo "$0 ${ARG}: ${APP_NAME}  could not be stopped"
    fi
    return ${RUNNING}
}

status_app() {
    is_running
    echo "${APP_STATUS}"
}

restart_app() {
    stop_app
    RUNNING=$?
    if [ ${RUNNING} -eq 0 ]; then
        start_app
    fi
}

ARG=$1
if [ "x$1" = "xhelp" ] || [ "x$1" = "x" ]; then
    help
elif [ "x$1" = "xstart" ]; then
    start_app
elif [ "x$1" = "xrestart" ]; then
    restart_app
elif [ "x$1" = "xstop" ]; then
    stop_app
elif [ "x$1" = "xstatus" ]; then
    status_app
else
    help
fi