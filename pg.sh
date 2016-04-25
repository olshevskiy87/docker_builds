#!/usr/bin/env bash

if [[ ! "${PGDATA}" ]]; then
    echo "\$PGDATA variable is not specified"
    exit 1
fi
if [[ ! "$(which pg_config)" ]]; then
    echo "pg_config not found"
    exit 1
fi

pgbin="$(pg_config --bindir)"
if [[ ! "${pgbin}" ]]; then
    echo "bindir config is not specified"
    exit 1
fi

is_running="$(pgrep postgres)"

case $1 in

    "status")
        if [[ "${is_running}" ]]; then
            echo "Running"
        else
            echo "Stopped"
        fi
        exit 0
        ;;

    "start")
        if [[ "${is_running}" ]]; then
            echo "Postgres is already running"
            exit 1
        fi
        if [[ ! -d "${PGDATA}" ]]; then
            echo "PG data directory does not exist"
            exit 1
        fi
        ${pgbin}/pg_ctl -l ${PGDATA}/pg.log start
        ;;

    "stop")
        if [[ ! -d "${PGDATA}" ]]; then
            echo "PG data directory does not exist"
            exit 1
        fi
        if [[ ! ${is_running} ]]; then
            echo "Postgres is not running"
            exit 1
        fi
        ${pgbin}/pg_ctl stop
        ;;

    "restart")
        $0 stop
        $0 start
        ;;

    "remake")
        if [[ ! -d "${PGGIT}" ]]; then
            echo "\$PGGIT is not specified or incorrect"
            exit 1
        fi

        read -p "Reset and make repo? " -n 1 -r
        if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
            echo
            exit 0
        fi
        echo

        cd ${PGGIT}

        make uninstall
        make clean

        git clean -fd
        git reset --hard HEAD
        git checkout master
        git pull

        ./configure --prefix=${PGDATA}
        make
        make install
        ;;

    "init")
        read -p "Remove PG data and init new cluster? " -n 1 -r
        if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
            echo
            exit 0
        fi
        echo

        $0 stop
        if [[ ! "$?" ]]; then
            echo "Could not init cluster, because PG is probably still running"
            exit 1
        fi

        rm -rf -R ${PGDATA}
        ${pgbin}/initdb
        ;;

    *)
        echo "Please specify the command"
        exit 0
        ;;
esac
