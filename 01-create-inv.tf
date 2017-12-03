resource "null_resource" "ansible-provision" {

  depends_on = ["aws_instance.k8s-master", "aws_instance.k8s-node"]

  ##Create Masters Inventory
  provisioner "local-exec" {
    command =  "echo \"[kube-master]\" > ansible/inventories/test"
  }
  provisioner "local-exec" {
    command =  "echo \"\n${join("\n",formatlist("%s ansible_ssh_host=%s", aws_instance.k8s-master.*.tags.Name, aws_instance.k8s-master.*.public_ip))}\" >> ansible/inventories/test"
  }

  ##Create ETCD Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\" >> ansible/inventories/test"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", aws_instance.k8s-master.*.tags.Name, aws_instance.k8s-master.*.public_ip))}\" >> ansible/inventories/test"
  }

  ##Create Nodes Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[kube-node]\" >> ansible/inventories/test"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", aws_instance.k8s-node.*.tags.Name, aws_instance.k8s-node.*.public_ip))}\" >> ansible/inventories/test"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> ansible/inventories/test"
  }
}
