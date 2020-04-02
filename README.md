# jenkins-dockercli-kubectl-oc
Jenkins official image extended with Docker, Kubernetes and Openshift cli's. With this image you'll have the 'docker', 'kubectl' and 'oc' commandline-interfaces on the PATH when running shell commands from you're Jenkins job.

To use the image properly run it in privileged mode. Create a volume on the hosts /var/run/docker.sock and point it to the same location in the container. Install the 'Docker'-plugin and configure a cloud that connects to 'unix:///var/run/docker.sock'. That way you've setup the container to use the hosts docker daemon. To use the kubectl-client you can create a credential with a token in it and point to it on every kubectl statement. Compatibility with other plugins is unknown, might be worth trying.
