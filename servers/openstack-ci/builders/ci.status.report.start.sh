#!/bin/bash -ex
export GERRIT_USER="openstack-ci-jenkins"
RELEASE=`echo $SOURCEBRANCH | egrep -o 'fuel-[0-9.]*' | egrep -o '[0-9.]*' | cat `
if [ `echo $JOB_NAME | grep deb` ] ; then
   if [ "$RELEASE" == "6.1" ] ; then export REQUEST_TYPE="Trusty" ; else export REQUEST_TYPE="Precise" ; fi ; DISTR="deb" ;
elif [ `echo $JOB_NAME | grep rpm` ] ; then export REQUEST_TYPE="Centos6" ; DISTR="rpm" ;
fi

if [ `echo $JOB_NAME | grep install` ] ; then export DISPLAY_NAME="Check $DISTR package for installation and simple testing" ;
elif [ `echo $JOB_NAME | grep deploy` ] ; then export DISPLAY_NAME="Check $DISTR package for installation in environment" ;
elif [ `echo $JOB_NAME | grep build` ] ; then
    CHANGENUMBER=`echo $GERRIT_REFSPEC | cut -d '/' -f4`
    status=`ssh ${GERRIT_USER}@${GERRIT_HOST} -p $GERRIT_PORT gerrit query --format=TEXT $CHANGENUMBER | egrep -o " +status:.*" | awk -F': ' '{print $2}'`
    if [ "$status" == "MERGED" ] ; then
        export DISPLAY_NAME="Build $DISTR package on primary repository" ;
    else
        export DISPLAY_NAME="Build $DISTR package on temporary repository" ;
    fi
fi
ci_status/ci-status-report.sh start