#!/bin/bash
set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << 'BANNER'
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║          Kmesh Advanced Load Balancing - Demo Runner          ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

# Check if image exists
echo -e "${YELLOW}Checking Docker image...${NC}"
if docker images | grep -q "kmesh-advanced-lb.*demo"; then
    echo -e "${GREEN}✅ Image found: kmesh-advanced-lb:demo${NC}"
else
    echo -e "${RED}❌ Image not found${NC}"
    echo -e "${YELLOW}Building image... (this may take a few minutes)${NC}"
    docker build -f Dockerfile.advanced-lb -t kmesh-advanced-lb:demo .
    echo -e "${GREEN}✅ Image built successfully${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  DEMO 1: Implementation Overview${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo ""
read -p "Press Enter to continue to build verification..."
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  DEMO 2: Build Verification${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

docker run --rm kmesh-advanced-lb:demo /opt/kmesh/demo/verify-build.sh

RESULT=$?

echo ""
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║                  🎉 Demo Successful! 🎉                         ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Summary:${NC}"
    echo -e "  ✅ Protobuf extensions compiled successfully"
    echo -e "  ✅ New LB policy enums (WEIGHTED_ROUND_ROBIN, STICKY_ROUND_ROBIN) generated"
    echo -e "  ✅ BPF connection tracking structures defined"
    echo -e "  ✅ BPF maps (map_of_conn_track, map_of_service_lb_state) declared"
    echo -e "  ✅ Go LB manager implemented"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo -e "  1. Integrate lb_advanced.h into service.h"
    echo -e "  2. Implement connection tracking logic in BPF programs"
    echo -e "  3. Add userspace controller integration"
    echo -e "  4. Write unit tests"
    echo -e "  5. Deploy to Kubernetes cluster for E2E testing"
else
    echo -e "${RED}⚠️  Some verification tests failed${NC}"
    echo -e "${YELLOW}Run with verbose mode to investigate:${NC}"
    echo -e "  docker run --rm -it kmesh-advanced-lb:demo /bin/bash"
fi

echo ""
echo -e "${BLUE}Additional Commands:${NC}"
echo -e "  Interactive shell:  ${YELLOW}docker run --rm -it kmesh-advanced-lb:demo /bin/bash${NC}"
echo -e "  Verify build:       ${YELLOW}docker run --rm kmesh-advanced-lb:demo /opt/kmesh/demo/verify-build.sh${NC}"
echo ""