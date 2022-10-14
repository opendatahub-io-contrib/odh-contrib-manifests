#!/bin/bash

source $TEST_DIR/common

MY_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)

RESOURCEDIR="${MY_DIR}/../resources"

source ${MY_DIR}/../util

os::test::junit::declare_suite_start "$MY_SCRIPT"

function check_operator() {
    header "Testing Ray Operator"
    os::cmd::expect_success "oc project ${ODHPROJECT}"
    os::cmd::try_until_text "oc get crd rayclusters.cluster.ray.io" "rayclusters.cluster.ray.io" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get role ray-operator" "ray-operator" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get rolebinding ray-operator" "ray-operator" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get sa ray-operator" "ray-operator" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get deployment ray-operator" "ray-operator" $odhdefaulttimeout $odhdefaultinterval
    os::cmd::try_until_text "oc get pods -l app=ray-operator --field-selector='status.phase=Running' -o jsonpath='{$.items[*].metadata.name}' | wc -w" "1" $odhdefaulttimeout $odhdefaultinterval

    
}

function check_cluster() {
    header "Testing Ray Cluser"
    os::cmd::expect_success "oc project ${ODHPROJECT}"
    os::cmd::try_until_text "oc get RayCluster -o jsonpath='{$.items[*].metadata.name}' | wc -w" "1" $odhdefaulttimeout $odhdefaultinterval
  }

function check_functionality(){
  header "Testing Ray Functionality "
  os::cmd::expect_success "oc project ${ODHPROJECT}"
  sleep 30
  os::cmd::expect_success "oc apply -f ${RESOURCEDIR}/ray/ray-simple-test.yaml"
  sleep 30
  os::cmd::try_until_text "oc get pods -l app=ray-simple-test -o jsonpath='{$.items[*].status.containerStatuses[0].lastState.terminated.exitCode}'" "" $odhdefaulttimeout $odhdefaultinterval
  os::cmd::try_until_text "oc get pods -l app=ray-simple-test -o jsonpath='{$.items[*].status.containerStatuses[0].restartCount}'" "0" $odhdefaulttimeout $odhdefaultinterval
  pod_name=($(oc get pods -l app=ray-simple-test -o jsonpath='{$.items[*].metadata.name}'))
  os::cmd::try_until_text "oc logs ${pod_name} | grep 'Simple tests passed'" "Simple tests passed" $odhdefaulttimeout $odhdefaultinterval
}

function setup_monitoring() {
    header "Enabling User Workload Monitoring on the cluster"
    oc apply -f ${RESOURCEDIR}/modelmesh/enable-uwm.yaml
}

function test_metrics() {
    header "Checking metrics"
    monitoring_token=$(oc sa get-token prometheus-k8s -n openshift-monitoring)
    oc label service ray-cluster-example-ray-head app=ray-monitor
    sleep 30
    os::cmd::try_until_text "oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 -- curl -k -H \"Authorization: Bearer $monitoring_token\" https://thanos-querier.openshift-monitoring.svc:9091/api/v1/query?query=ray_node_cpu_count | jq '.data.result[0].value[1]'" "2" $odhdefaulttimeout $odhdefaultinterval
}

setup_monitoring
check_operator
check_cluster
check_functionality
test_metrics

os::test::junit::declare_suite_end
