package containerresourcenotexceed


violation[{"msg": msg}] {
  # container.name := "test"
  limited_cpu := 1000
  container := input_containers[_]
  
  requested_cpu := container.resources.requests.cpu
  cpu := canonify_cpu(requested_cpu)
  cpu > limited_cpu
  msg := sprintf("container [%v] requested [%v]m cpus more than limited [%v]m ", [container.name, requested_cpu, limited_cpu])
  
  # gap := request - limited_cpu

  # gap > 0  
  # msg := sprintf("container  requested  %d cpus more than limited", [request])
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