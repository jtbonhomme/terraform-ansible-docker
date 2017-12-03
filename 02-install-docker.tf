variable "aws-ssh-key" {}

resource "null_resource" "ansible-docker" {

  depends_on = ["aws_instance.k8s-master", "aws_instance.k8s-node", "null_resource.ansible-provision"]

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key '${var.aws-ssh-key}' -i ansible/inventories/test ansible/roles/docker/tasks/docker.yml"
  }
}
