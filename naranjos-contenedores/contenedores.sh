# NaranjOS · lazydocker (y lo que hable «docker») usa el Podman de tu usuario
[ -n "${XDG_RUNTIME_DIR:-}" ] && export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
