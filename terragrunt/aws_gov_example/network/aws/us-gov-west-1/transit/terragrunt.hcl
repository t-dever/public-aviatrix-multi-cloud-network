include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/aws/transits.hcl"
}

inputs = {
  tag_prefix              = "travis-aviatrix-gov"
  deploy_palo_alto_firewalls = {
    s3_bucket_name = "travis-usgovwest1-bootstrap-bucket",
    s3_iam_role_name = "travis-usgovwest1-bootstrap-s3-role",
    aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaRtS3j6rvVE1HkWNUwTh6JcMBudrSiiEh4jF8tbJunJybDw+afo71OYetIs7/pq1UQW5Ffwi/z/bTvYleF/IV3Tp9NLhqyfee4WzZESfGxqdchDqa0pkDpYEq+Rh11x8VQ4P4BcgYvNOHh0UbMM77ftMWrxPDY7sCnYGAShbz7lPVSEYsuEfj2QUVmrkPYKGC6qytYfZkj1jH3VnetFTFosinJUgyWRvGXyzkSGEHXNttUs7a5SYwiNbyc+O/yi7Xce0Jtuf7nRwo/+E2pIuV3ohitW4PvPUwmiBajLqcwwG0Rw2Qu/cgzHlK4kphkcSBePoyr4u1CtqClPha+ShluzdM0MKskrwGxQlwaX6z5EYgiUc6PBwaA6LAv48lvF49kpYbyJ3tE2TN/wZm+rKp4ZSMOXATJZsMDrygsDD57fF21R1nR+0zx5AtpW9A7iQYsvkWAuDMelRgWPhiS0EvIAMVkwi8MCRXwjS1FMj2E+SJoZGg1dqNoVNdf7dx5EM= aws_firewalls",
    aws_firewall_key_pair_name = "travis-aviatrix-firenet-key",
    firewall_private_key_location = "${get_env("AWS_FIREWALL_PRIVATE_KEY_LOCATION")}",
    firewall_password = "",
    store_firewall_password_in_ssm = true,
    firewalls = [
      {
        name = "travis-test-firewall-1"
      }
    ]
    firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1",
    firewall_image_version = "10.1.4",
    firewall_size = "m5.xlarge"
  }
}