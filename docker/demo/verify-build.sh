#!/usr/bin/env bash
set -euo pipefail

SUCCESS=0
FAIL=0

echo "TEST 1: protobuf C files"
if [ -f /opt/kmesh/api/v2-c/cluster/cluster.pb-c.c ]; then
  echo "  cluster.pb-c.c exists"
  ls -lh /opt/kmesh/api/v2-c/cluster/cluster.pb-c.* 2>/dev/null | awk '{print "    "$9" ("$5")"}' || true
  SUCCESS=$((SUCCESS+1))
else
  echo "  cluster.pb-c.c missing"
  FAIL=$((FAIL+1))
fi

echo "TEST 2: WEIGHTED_ROUND_ROBIN enum"
if grep -q "WEIGHTED_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h 2>/dev/null; then
  echo "  WEIGHTED_ROUND_ROBIN found"
  grep "WEIGHTED_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h | head -1 | sed 's/^/    /'
  SUCCESS=$((SUCCESS+1))
else
  echo "  WEIGHTED_ROUND_ROBIN not found"
  FAIL=$((FAIL+1))
fi

echo "TEST 3: STICKY_ROUND_ROBIN enum"
if grep -q "STICKY_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h 2>/dev/null; then
  echo "  STICKY_ROUND_ROBIN found"
  grep "STICKY_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h | head -1 | sed 's/^/    /'
  SUCCESS=$((SUCCESS+1))
else
  echo "  STICKY_ROUND_ROBIN not found"
  FAIL=$((FAIL+1))
fi

echo "TEST 4: lb_advanced.h"
if [ -f /kmesh/bpf/kmesh/workload/include/lb_advanced.h ]; then
  echo "  lb_advanced.h exists"
  wc -l /kmesh/bpf/kmesh/workload/include/lb_advanced.h | awk '{print "    Lines: "$1}'
  SUCCESS=$((SUCCESS+1))
else
  echo "  lb_advanced.h missing"
  FAIL=$((FAIL+1))
fi

echo "TEST 5: BPF map definitions"
if grep -q "map_of_conn_track" /kmesh/bpf/kmesh/workload/include/lb_advanced.h 2>/dev/null; then
  echo "  map_of_conn_track found"
  grep -n "map_of_conn_track" /kmesh/bpf/kmesh/workload/include/lb_advanced.h | head -1 | sed 's/^/    Line /'
  SUCCESS=$((SUCCESS+1))
else
  echo "  map_of_conn_track not found"
  FAIL=$((FAIL+1))
fi

echo "TEST 6: API shared library"
if [ -f /usr/local/lib/libkmesh_api_v2_c.so ]; then
  echo "  libkmesh_api_v2_c.so exists"
  ls -lh /usr/local/lib/libkmesh_api_v2_c.so | awk '{print "    "$9" ("$5")"}'
  SUCCESS=$((SUCCESS+1))
else
  echo "  libkmesh_api_v2_c.so missing"
  FAIL=$((FAIL+1))
fi

echo "TEST 7: Go LB manager"
if [ -f /kmesh/pkg/controller/workload/lbmanager/lb_manager.go ]; then
  echo "  lb_manager.go exists"
  wc -l /kmesh/pkg/controller/workload/lbmanager/lb_manager.go | awk '{print "    Lines: "$1}'
  SUCCESS=$((SUCCESS+1))
else
  echo "  lb_manager.go missing"
  FAIL=$((FAIL+1))
fi

echo "RESULT: $SUCCESS passed | $FAIL failed"

if [ "$FAIL" -eq 0 ]; then
  exit 0
else
  exit 1
fi