<% if false # the license inside this if block assertains to this file -%>
# Copyright 2017 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
<% end -%>
<% unless name == "README.md" -%>
<%= compile 'templates/license.erb' -%>

<%= compile 'templates/autogen_notice.erb' -%>

<%= compile 'templates/puppet/examples~credential.pp.erb' -%>

gcompute_zone { 'us-central1-a':
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_instance_group { <%= example_resource_name('my-puppet-masters') -%>:
  ensure     => present,
  zone       => 'us-central1-a',
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_backend_service { <%= example_resource_name('my-tcp-backend') -%>:
  ensure        => present,
  backends      => [
    { group => <%= example_resource_name('my-puppet-masters') -%> },
  ],
  health_checks => [
    gcompute_health_check_ref('another-hc', 'google.com:graphite-playground'),
  ],
  protocol      => 'TCP',
  project       => 'google.com:graphite-playground',
  credential    => 'mycred',
}

<% end # name == README.md -%>
gcompute_target_tcp_proxy { <%= example_resource_name('my-tcp-proxy') -%>:
  ensure       => present,
  proxy_header => 'PROXY_V1',
  service      => <%= example_resource_name('my-tcp-backend') -%>,
  project      => 'google.com:graphite-playground',
  credential   => 'mycred',
}
