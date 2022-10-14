#!/bin/bash

source $TEST_DIR/common

MY_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)

source ${MY_DIR}/../util

os::test::junit::declare_suite_start "$MY_SCRIPT"

function test_pachyderm() {
    
    header "Verify Pachyderm"
    os::cmd::expect_success "oc project ${ODHPROJECT}"
    os::cmd::try_until_text "oc get deployment pachd -n ${ODHPROJECT}" "pachd" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get deployment pg-bouncer -n ${ODHPROJECT}" "pg-bouncer" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get statefulset etcd -n ${ODHPROJECT}" "etcd" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get statefulset postgres -n ${ODHPROJECT}" "postgres" $odhdefaulttimeout $odhdefaultinterval
    
    sleep 10
    
    os::cmd::try_until_not_text "oc get pod -l app=pachd --field-selector='status.phase=Running' -n ${ODHPROJECT}" "No resources found" $odhdefaulttimeout $odhdefaultinterval

    runningpods=($(oc get pods -l suite=pachyderm --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}" -n ${ODHPROJECT}))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "3"
}

test_pachyderm

os::test::junit::declare_suite_end
