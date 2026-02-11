#!/bin/bash

echo "═══════════════════════════════════════════════════════════"
echo "  Kmesh Advanced LB - Build Verification"
echo "═══════════════════════════════════════════════════════════"
echo ""

SUCCESS=0
FAIL=0

# Test 1: Protobuf C files
echo "TEST 1: Checking protobuf C files..."
if [ -f /opt/kmesh/api/v2-c/cluster/cluster.pb-c.c ]; then
    echo "  ✅ cluster.pb-c.c exists"
    ls -lh /opt/kmesh/api/v2-c/cluster/cluster.pb-c.* | awk '{print "     "$9" ("$5")"}'
    ((SUCCESS++))
else
    echo "  ❌ cluster.pb-c.c NOT found"
    ((FAIL++))
fi
echo ""

# Test 2: WEIGHTED_ROUND_ROBIN enum
echo "TEST 2: Checking WEIGHTED_ROUND_ROBIN enum..."
if grep -q "WEIGHTED_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h 2>/dev/null; then
    echo "  ✅ WEIGHTED_ROUND_ROBIN found in C header"
    grep "WEIGHTED_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h | head -1 | sed 's/^/     /'
    ((SUCCESS++))
else
    echo "  ❌ WEIGHTED_ROUND_ROBIN NOT found"
    ((FAIL++))
fi
echo ""

# Test 3: STICKY_ROUND_ROBIN enum
echo "TEST 3: Checking STICKY_ROUND_ROBIN enum..."
if grep -q "STICKY_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h 2>/dev/null; then
    echo "  ✅ STICKY_ROUND_ROBIN found in C header"
    grep "STICKY_ROUND_ROBIN" /opt/kmesh/api/v2-c/cluster/cluster.pb-c.h | head -1 | sed 's/^/     /'
    ((SUCCESS++))
else
    echo "  ❌ STICKY_ROUND_ROBIN NOT found"
    ((FAIL++))
fi
echo ""

# Test 4: lb_advanced.h header
echo "TEST 4: Checking lb_advanced.h..."
if [ -f /kmesh/bpf/kmesh/workload/include/lb_advanced.h ]; then
    echo "  ✅ lb_advanced.h exists"
    wc -l /kmesh/bpf/kmesh/workload/include/lb_advanced.h | awk '{print "     Lines: "$1}'
    ((SUCCESS++))
else
    echo "  ❌ lb_advanced.h NOT found"
    ((FAIL++))
fi
echo ""

# Test 5: BPF map definitions
echo "TEST 5: Checking BPF map definitions..."
if grep -q "map_of_conn_track" /kmesh/bpf/kmesh/workload/include/lb_advanced.h 2>/dev/null; then
    echo "  ✅ map_of_conn_track found"
    grep -n "map_of_conn_track" /kmesh/bpf/kmesh/workload/include/lb_advanced.h | head -1 | sed 's/^/     Line /'
    ((SUCCESS++))
else
    echo "  ❌ map_of_conn_track NOT found"
    ((FAIL++))
fi
echo ""

# Test 6: Shared library
echo "TEST 6: Checking API shared library..."
if [ -f /usr/local/lib/libkmesh_api_v2_c.so ]; then
    echo "  ✅ libkmesh_api_v2_c.so exists"
    ls -lh /usr/local/lib/libkmesh_api_v2_c.so | awk '{print "     "$9" ("$5")"}'
    ((SUCCESS++))
else
    echo "  ❌ libkmesh_api_v2_c.so NOT found"
    ((FAIL++))
fi
echo ""

# Test 7: Go LB manager
echo "TEST 7: Checking Go LB manager..."
if [ -f /kmesh/pkg/controller/workload/lbmanager/lb_manager.go ]; then
    echo "  ✅ lb_manager.go exists"
    wc -l /kmesh/pkg/controller/workload/lbmanager/lb_manager.go | awk '{print "     Lines: "$1}'
    ((SUCCESS++))
else
    echo "  ❌ lb_manager.go NOT found"
    ((FAIL++))
fi
echo ""

# Summary
echo "═══════════════════════════════════════════════════════════"
echo "  RESULTS: ✅ $SUCCESS passed  |  ❌ $FAIL failed"
echo "═══════════════════════════════════════════════════════════"

if [ $FAIL -eq 0 ]; then
    echo "  🎉 All tests passed!"
    exit 0
else
    echo "  ⚠️  Some tests failed"
    exit 1
fi