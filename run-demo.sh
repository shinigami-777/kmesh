#!/usr/bin/env bash
set -euo pipefail

# Check image
if docker image inspect kmesh-advanced-lb:demo >/dev/null 2>&1; then
  echo "Image kmesh-advanced-lb:demo found"
else
  echo "Building kmesh-advanced-lb:demo..."
  docker build -f Dockerfile.advanced-lb -t kmesh-advanced-lb:demo .
fi

echo
read -r -p "Press Enter to continue to build verification..."

echo
echo "DEMO : Build Verification"
docker run --rm kmesh-advanced-lb:demo /opt/kmesh/demo/verify-build.sh
RESULT=$?

echo
if [ "$RESULT" -eq 0 ]; then
  echo "Demo successful."
  echo "Summary:"
  echo "  - Protobuf extensions compiled"
  echo "  - New LB policy enums generated"
  echo "  - BPF connection tracking structures defined"
  echo "  - BPF maps declared"
  echo "  - Go LB manager implemented"
  echo
  echo "Next steps:"
  echo "  1. Integrate lb_advanced.h into service.h"
  echo "  2. Implement connection tracking logic in BPF programs"
  echo "  3. Add userspace controller integration"
  echo "  4. Write unit tests"
  echo "  5. Deploy to Kubernetes for E2E testing"
else
  echo "Verification tests failed. To investigate, run:"
  echo "  docker run --rm -it kmesh-advanced-lb:demo /bin/bash"
fi

echo
echo "Useful commands:"
echo "  docker run --rm -it kmesh-advanced-lb:demo /bin/bash"
echo "  docker run --rm kmesh-advanced-lb:demo /opt/kmesh/demo/verify-build.sh"