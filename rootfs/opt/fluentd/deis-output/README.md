# Deis Fluentd plugin
Deis (pronounced DAY-iss) Workflow is an open source Platform as a Service (PaaS) that adds a developer-friendly layer to any [Kubernetes](http://kubernetes.io) cluster, making it easy to deploy and manage applications on your own servers.

For more information about the Deis Workflow, please visit the main project page at https://github.com/deis/workflow.

## About
[Fluentd](http://www.fluentd.org/) is an integral part of the [Deis Workflow](https://github.com/deis/workflow) stack. It is responsible for consuming all of the log data produced by the Kuberenetes cluster. This includes the kubernetes components, Workflow components, and user deployed applications. This plugin takes that log data and will forward it to the appropriate Workflow components.

## License

© Engine Yard, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
