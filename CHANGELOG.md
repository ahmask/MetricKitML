# Changelog

All notable changes to MetricKitML are documented here.

## [1.3.0] — 2026-04-08

### Added
- `StandardClassificationReporter` in `MetricKitML` core target — ready-to-use `EvaluationReporter`
  for multi-class text classification with configurable accuracy threshold (default 0.85)
- `PrecisionRecallF1.ConfusionMatrix` struct and `confusionMatrix` property on `PrecisionRecallF1.Output` —
  `matrix[i][j]` = count(expected == labels[i] && predicted == labels[j]), with `count(expected:predicted:)` helper
- `MetricKitMLCoreMLTests` target with unit tests for `CoreMLLatencyRunner`
  (correct, incorrect, throwing, latency capture, ID propagation)
- `MetricKitMLFoundationTests` target with unit tests for `FoundationModelRunner`
  (score-based correctness, substring-match correctness, hallucination flag, secondary score, error capture)
- Tests for `LatencyMeasurer.measureCapturingErrors` success and error paths
- Tests for `StandardClassificationReporter` (pass/fail thresholds, custom threshold, latency metrics)
- Tests for `PrecisionRecallF1.ConfusionMatrix` (perfect, misclassifications, unknown label)

### Changed
- `FoundationModelRunner.run(_:)` — documented `isCorrect` fallback semantics in public doc comment:
  score-based when `score` is provided (`score >= 1.0`), case-insensitive substring match otherwise



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
