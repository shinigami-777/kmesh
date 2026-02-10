// Copyright Authors of Kmesh
// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

package lbmanager

import (
	"fmt"
	"hash/fnv"
)

const (
	LB_POLICY_RANDOM               = 0
	LB_POLICY_STRICT               = 1
	LB_POLICY_FAILOVER             = 2
	LB_POLICY_WEIGHTED_ROUND_ROBIN = 3
	LB_POLICY_STICKY_ROUND_ROBIN   = 4
)

// BackendWeight represents a backend with its weight
type BackendWeight struct {
	BackendUID    uint32
	Weight        uint32
	CurrentWeight uint32
}

// ServiceLBState represents the load balancing state for a service
type ServiceLBState struct {
	ServiceID       uint32
	LastSelectedIdx uint32
	BackendCount    uint32
	Backends        []BackendWeight
}

// LBManager manages advanced load balancing state
type LBManager struct {
	// In a full implementation, this would hold BPF map references
}

// NewLBManager creates a new load balancing manager
func NewLBManager() *LBManager {
	return &LBManager{}
}

// UpdateServiceLBState updates the load balancing state for a service
func (lbm *LBManager) UpdateServiceLBState(serviceID uint32, endpoints []string, weights []uint32, policy uint32) error {
	if len(endpoints) == 0 {
		return fmt.Errorf("no endpoints provided")
	}

	// If no weights provided, use equal weights
	if len(weights) == 0 {
		weights = make([]uint32, len(endpoints))
		for i := range weights {
			weights[i] = 100 // Default weight
		}
	}

	if len(endpoints) != len(weights) {
		return fmt.Errorf("endpoints and weights length mismatch")
	}

	// In full implementation: Update BPF map_of_service_lb_state here
	return nil
}

// Helper function to hash UID
func hashUID(uid string) uint32 {
	h := fnv.New32a()
	h.Write([]byte(uid))
	return h.Sum32()
}
