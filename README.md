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

Planned:

- Service health monitoring
- Syncthing monitoring
- Log analysis
- Alerting and threshold checks
- Scheduled reporting with cron
- Historical metrics collection
- Dashboard generation

## Example Output

```text
=== System Health Report ===

Hostname: raspberrypi
Date: 2026-06-11 14:00

CPU Usage: 12%
Memory Usage: 48%
Disk Usage: 62%

Uptime: 14 days
```

## Requirements

- Linux
- Bash
- Core GNU utilities

Tested on:

- Raspberry Pi OS

## Installation

Clone the repository:

```bash
git clone https://github.com/<username>/pi-monitor.git
cd pi-monitor
```

Make the script executable:

```bash
chmod +x monitor.sh
```

Run:

```bash
./monitor.sh
```

## Project Structure

```text
pi-monitor/
├── monitor.sh
├── config.sh
├── reports/
├── docs/
├── screenshots/
└── README.md
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
- [ ] Memory usage
- [ ] Disk usage
- [ ] Uptime reporting

### Phase 2 - Service Monitoring

- [ ] Check service status
- [ ] Monitor Syncthing
- [ ] Track resource consumption

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
