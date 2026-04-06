# Changelog

All notable changes to MetricKitML are documented here.

## [1.0.0] — 2026-04-06

### Added
- `EvaluationCase`, `EvaluationRunner`, `EvaluationReporter` protocols in `MetricKitML` core target
- `EvaluationResult`, `EvaluationMetrics`, `EvaluationReport` model structs
- `PrecisionRecallF1` — accuracy, per-class P/R/F1, macro and weighted averages
- `LatencyMeasurer` — wall-clock latency measurement for async operations
- `P90Calculator` — percentile, mean, and standard deviation statistics
- `CoreMLTextCase` and `CoreMLLatencyRunner` in `MetricKitMLCoreML` target
- `FoundationModelCase` and `FoundationModelRunner` in `MetricKitMLFoundation` target
- Unit tests for all metric functions
- GitHub Actions CI workflow (`test-package.yml`)
