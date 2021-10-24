terraform {
  required_providers {
    #
    # Tinkerbell
    #
    # Docs: https://registry.terraform.io/providers/tinkerbell/tinkerbell/latest/docs
    #
    tinkerbell = {
      source  = "tinkerbell/tinkerbell"
      version = "0.1.1"
    }
  }
}

provider "tinkerbell" {
  grpc_authority = "tink-grpc-cont.service.kjdev:42113"
  cert_url       = "http://tink-http-cont.service.kjdev:42114/cert"
}

resource "tinkerbell_hardware" "foo" {
  data = <<EOF
{
  "id": "0eba0bf8-3772-4b4a-ab9f-6ebe93b90a94",
  "metadata": {
    "facility": {
      "facility_code": "onprem",
      "plan_slug": "c2.medium.x86",
      "plan_version_slug": ""
    },
    "instance": {},
    "state": "provisioning"
  },
  "network": {
    "interfaces": [
      {
        "dhcp": {
          "arch": "x86_64",
          "ip": {
            "address": "172.16.0.99",
            "gateway": "172.16.0.1",
            "netmask": "255.255.255.128"
          },
          "mac": "00:50:56:be:c4:1c",
          "name_servers": [
            "172.16.0.1"
          ],
          "uefi": true
        },
        "netboot": {
          "allow_pxe": true,
          "allow_workflow": true
        }
      }
    ]
  }
}
EOF
}

resource "tinkerbell_template" "foo" {
  name    = "foo"
  content = <<EOF
version: "0.1"
name: hello_world_workflow
global_timeout: 600
tasks:
  - name: "hello world"
    worker: "{{.device_1}}"
    actions:
      - name: "hello_world"
        image: hello-world
        timeout: 60
EOF
}

resource "tinkerbell_workflow" "TestSRV1" {
  template  = tinkerbell_template.foo.id
  hardwares = <<EOF
{"device_1":"172.16.0.71"}
EOF

  depends_on = [
    tinkerbell_hardware.foo,
  ]
}

resource "tinkerbell_workflow" "TestSRV2" {
  template  = tinkerbell_template.foo.id
  hardwares = <<EOF
{"device_1":"172.16.0.72"}
EOF

  depends_on = [
    tinkerbell_hardware.foo,
  ]
}


resource "tinkerbell_workflow" "TestSRV3" {
  template  = tinkerbell_template.foo.id
  hardwares = <<EOF
{"device_1":"172.16.0.73"}
EOF

  depends_on = [
    tinkerbell_hardware.foo,
  ]
}


resource "tinkerbell_workflow" "Home1" {
  template  = tinkerbell_template.foo.id
  hardwares = <<EOF
{"device_1":"172.31.241.37"}
EOF

  depends_on = [
    tinkerbell_hardware.foo,
  ]
}

