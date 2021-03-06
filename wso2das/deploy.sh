#!/bin/bash
# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------

set -e
self_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mesos_artifacts_home="${self_path}/.."
source "${mesos_artifacts_home}/common/scripts/base.sh"

wso2_das_marathon_app_id=wso2das-default
mysql_das_db_host_port=10061
wso2das_default_service_port=9443
wso2das_thrift_port=7611
wso2das_secure_thrift_port=7711

function deploy_default() {
  echoBold "Deploying WSO2 DAS default setup on Mesos..."
  deploy_common_services
  deploy_service 'mysql-das-db' $mysql_das_db_host_port
  deploy_service 'wso2das-default' $wso2das_default_service_port
  echoBold "wso2das-default management console: https://${marathonlb_host_ip}:${wso2das_default_service_port}/carbon"
  echoBold "wso2das-default thrift endpoint: tcp://${wso2_das_marathon_app_id}.marathon.mesos:${wso2das_thrift_port}"
  echoBold "wso2das-default thrift secure endpoint: tcp://${wso2_das_marathon_app_id}.marathon.mesos:${wso2das_secure_thrift_port}"
  echoSuccess "Successfully deployed WSO2 DAS default setup on Mesos"
}

function main () {
  while getopts :sh FLAG; do
      case $FLAG in
          h)
              showUsageAndExitDistributed
              ;;
          \?)
              showUsageAndExitDistributed
              ;;
      esac
  done
  deploy_default
}
main "$@"
