package containerresourcenotexceed

violation[{"msg": msg}] {
  specified_cpu :=  to_number(input.parameters.cpu)*1000
  container := input_containers[_]
  requested_cpu := container.resources.requests.cpu
  cpu := canonify_cpu(requested_cpu)
  cpu > specified_cpu
  msg := sprintf("container [%v] requested [%v]m cpus more than limited [%v]m ", [container.name, cpu, specified_cpu])
}

canonify_cpu(orig) = new {
  is_number(orig)
  new := orig * 1000
}

canonify_cpu(orig) = new {
  not is_number(orig)
  endswith(orig, "m")
  new := to_number(replace(orig, "m", ""))
}

canonify_cpu(orig) = new {
  not is_number(orig)
  not endswith(orig, "m")
  re_match("^[0-9]+(\\.[0-9]+)?$", orig)
  new := to_number(orig) * 1000
}


input_containers[c] {
   c := input.spec.containers[_]
}

input_containers[c] {
   c := input.spec.initContainers[_]
}