# Pi Monitor

A lightweight Linux monitoring toolkit for Raspberry Pi written in
Bash.

The goal of this project is to learn Linux system administration,
shell scripting, automation, and monitoring concepts by building a
practical tool that runs on real hardware.

## Features

Current:

- Generate basic system health reports
- Display CPU usage
- Display memory usage
- Display disk usage
- Display uptime
- Service health monitoring
- Syncthing monitoring

Planned:

- Log analysis
- Alerting and threshold checks
- Scheduled reporting with cron
- Historical metrics collection
- Dashboard generation

## Example Output

`system_monitor.sh`:

```text
=== System Health Report ===

Hostname: DietPi
Date: 2026-06-23 13:00:18

CPU Usage: 0.3%
Memory Usage: 11.8%
Disk usage: 16%
Uptime: 12 days 1 hours 45 minutes

Top memory process: syncthing (4.7%)
```

`syncthing_monitor.sh`:

```text
=== Syncthing Status ===

Service status: active
Service enabled: enabled
PID: 39096
Memory: 2.2%
CPU: 0.0%

Sync folders:
- /mnt/dietpi_userdata/syncthing/notes 1.2M
```

## Learning Objectives

This project is intended to demonstrate and improve skills in:

- Bash scripting
- Linux system administration
- Process management
- Log analysis
- Automation
- Monitoring and observability
- Service management
- Documentation

## Roadmap

### Phase 1 - Basic Monitoring

- [x] CPU usage
- [x] Memory usage
- [x] Disk usage
- [x] Uptime reporting
- [x] Top memory process

### Phase 2 - Service Monitoring

- [x] Check service status
- [x] Monitor Syncthing
- [x] Track resource consumption
- [x] Detect Syncthing runtime user and home

### Phase 3 - Log Analysis

- [ ] Parse system logs
- [ ] Detect failed logins
- [ ] Summarize warnings and errors

### Phase 4 - Alerting

- [ ] Disk usage thresholds
- [ ] Memory usage thresholds
- [ ] Alert logging

### Phase 5 - Historical Metrics

- [ ] Store metrics in CSV format
- [ ] Generate trend reports

### Phase 6 - Dashboard

- [ ] Generate HTML reports
- [ ] Visualize historical metrics

## Motivation

This project was created as a hands-on way to learn Linux monitoring
and automation while maintaining a Raspberry Pi used for self-hosted
services such as Syncthing.
