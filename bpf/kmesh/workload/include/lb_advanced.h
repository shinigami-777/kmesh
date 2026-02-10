/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
/* Copyright Authors of Kmesh */

#ifndef __LB_ADVANCED_H__
#define __LB_ADVANCED_H__

#include "workload_common.h"
#include "workload.h"

#define MAX_BACKENDS 256
#define CONNECTION_TIMEOUT_NS 300000000000ULL  // 5 minutes in nanoseconds

// Extended load balancing policy types
typedef enum {
    LB_POLICY_RANDOM = 0,
    LB_POLICY_STRICT = 1,
    LB_POLICY_FAILOVER = 2,
    LB_POLICY_WEIGHTED_ROUND_ROBIN = 3,
    LB_POLICY_STICKY_ROUND_ROBIN = 4,
} lb_policy_extended_t;

// Connection tracking key - identifies a unique connection
typedef struct {
    __u32 src_ip;
    __u32 dst_ip;
    __u16 src_port;
    __u16 dst_port;
    __u8 protocol;
    __u8 pad[3];  // Padding for alignment
} __attribute__((packed)) conn_key_t;

// Connection tracking value - stores selected backend for this connection
typedef struct {
    __u32 backend_uid;      // Selected backend for this connection
    __u64 last_access_time; // Timestamp of last packet (for cleanup)
    __u8 is_active;         // Connection active flag
    __u8 pad[7];            // Padding for alignment
} conn_value_t;

// Backend weight information for weighted algorithms
typedef struct {
    __u32 backend_uid;
    __u32 weight;           // Weight for weighted algorithms (1-100)
    __u32 current_weight;   // Current effective weight (for WRR algorithm)
} backend_weight_t;

// Service load balancing state
typedef struct {
    __u32 service_id;
    __u32 last_selected_idx;        // For round robin
    __u32 backend_count;
    backend_weight_t backends[MAX_BACKENDS];
} service_lb_state_t;

// BPF Map: Connection tracking map - maps connections to selected backends
struct {
    __uint(type, BPF_MAP_TYPE_LRU_HASH);
    __uint(key_size, sizeof(conn_key_t));
    __uint(value_size, sizeof(conn_value_t));
    __uint(max_entries, 65536);  // Support 64k concurrent connections
} map_of_conn_track SEC(".maps");

// BPF Map: Service LB state map - stores per-service LB state
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(key_size, sizeof(__u32));  // service_id
    __uint(value_size, sizeof(service_lb_state_t));
    __uint(max_entries, 4096);
    __uint(map_flags, BPF_F_NO_PREALLOC);
} map_of_service_lb_state SEC(".maps");

#endif // __LB_ADVANCED_H__
