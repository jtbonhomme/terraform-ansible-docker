resource "null_resource" "ansible-provision" {
  depends_on = [aws_instance.ec2-master]

  ##Create Masters Inventory
  ##Create Masters Inventory
  provisioner "local-exec" {
    command = "echo \"[ec2-master]\" > ansible/inventories/test"
  }
  provisioner "local-exec" {
    command = "echo \"\n${format(
      "%s ansible_ssh_host=%s",
      aws_instance.ec2-master.tags.Name,
      aws_instance.ec2-master.public_ip,
    )}\" >> ansible/inventories/test"
  }
  provisioner "local-exec" {
    command = "echo \"${format(
      "EC2 instance: %s host public IP: %s",
      aws_instance.ec2-master.tags.Name,
      aws_instance.ec2-master.public_ip,
    )}\" "
  }
}

