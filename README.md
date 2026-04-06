# MetricKitML

MetricKitML is a Swift Package that provides the evaluation backbone for on-device AI features — protocols, models, and metric calculators that work with CoreML and Apple Foundation Models without sending any data off-device.

## Installation

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/ahmask/MetricKitML", from: "1.0.0")
```

Or add it as a local package during development:

```swift
.package(path: "../MetricKitML")
```

## Which target to import

| Target | Use when |
|---|---|
| `MetricKitML` | Core protocols and models only — no ML imports. Works in any project. |
| `MetricKitMLCoreML` | Your feature uses CoreML for classification (e.g. `.mlmodel`). |
| `MetricKitMLFoundation` | Your feature uses Apple Foundation Models (`LanguageModelSession`). |

## Minimal working example

```swift
import MetricKitML

// 1. Define a test case
struct MyCase: EvaluationCase {
    let id: String
    let input: String
    let expectedOutput: String
}

// 2. Implement a runner
struct MyRunner: EvaluationRunner {
    func run(_ testCase: MyCase) async throws -> EvaluationResult {
        let (predicted, latencyMs) = await LatencyMeasurer.measure {
            myModel.predict(testCase.input)
        }
        return EvaluationResult(
            id: testCase.id,
            isCorrect: predicted == testCase.expectedOutput,
            latencyMs: latencyMs,
            predictedLabel: predicted,
            expectedLabel: testCase.expectedOutput
        )
    }
}

// 3. Run all cases and compute metrics
let results = try await testCases.asyncMap { try await MyRunner().run($0) }
let metrics = PrecisionRecallF1.compute(from: results, labels: MyLabel.allRawValues)
```

## How to add a new feature evaluation

1. Define your test case struct conforming to `EvaluationCase`.
2. Implement `EvaluationRunner.run(_:)` — call your model, measure latency, return `EvaluationResult`.
3. Implement `EvaluationReporter.report(from:featureName:)` — compute `EvaluationMetrics` and decide `passedBaseline`.
4. Wire the reporter to your evaluation UI or CI workflow.

## Privacy

All evaluation runs entirely on-device. No user input, model output, or evaluation data is ever sent to a network endpoint or written outside the test bundle. The privacy comment `// MetricKitML — all processing is on-device. No data leaves the device.` appears at the top of every public file.

## CI

The `test-package.yml` workflow runs `swift test` on every push and pull request to `main`.

[![Test MetricKitML Package](https://github.com/ahmask/MetricKitML/actions/workflows/test-package.yml/badge.svg)](https://github.com/ahmask/MetricKitML/actions/workflows/test-package.yml)
