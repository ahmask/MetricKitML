// MetricKitML — all processing is on-device. No data leaves the device.
//
// MetricsTests.swift
// MetricKitMLTests

import XCTest
@testable import MetricKitML

final class MetricsTests: XCTestCase {

    // MARK: - PrecisionRecallF1

    func test_precisionRecallF1_perfect() {
        let results = [
            EvaluationResult(id: "1", isCorrect: true, latencyMs: 10, predictedLabel: "cat", expectedLabel: "cat"),
            EvaluationResult(id: "2", isCorrect: true, latencyMs: 12, predictedLabel: "dog", expectedLabel: "dog")
        ]
        let output = PrecisionRecallF1.compute(from: results, labels: ["cat", "dog"])
        XCTAssertEqual(output.accuracy, 1.0)
        XCTAssertEqual(output.macroF1, 1.0)
        XCTAssertEqual(output.weightedF1, 1.0)
    }

    func test_precisionRecallF1_allWrong() {
        let results = [
            EvaluationResult(id: "1", isCorrect: false, latencyMs: 10, predictedLabel: "dog", expectedLabel: "cat"),
            EvaluationResult(id: "2", isCorrect: false, latencyMs: 12, predictedLabel: "cat", expectedLabel: "dog")
        ]
        let output = PrecisionRecallF1.compute(from: results, labels: ["cat", "dog"])
        XCTAssertEqual(output.accuracy, 0.0)
        XCTAssertEqual(output.macroF1, 0.0)
    }

    func test_precisionRecallF1_classMetrics() {
        // 2 cats, 1 dog — model predicts correctly for both cats, misses dog
        let results = [
            EvaluationResult(id: "1", isCorrect: true,  latencyMs: 10, predictedLabel: "cat", expectedLabel: "cat"),
            EvaluationResult(id: "2", isCorrect: true,  latencyMs: 10, predictedLabel: "cat", expectedLabel: "cat"),
            EvaluationResult(id: "3", isCorrect: false, latencyMs: 10, predictedLabel: "cat", expectedLabel: "dog")
        ]
        let output = PrecisionRecallF1.compute(from: results, labels: ["cat", "dog"])
        let catMetrics = output.classMetrics.first { $0.label == "cat" }!
        let dogMetrics = output.classMetrics.first { $0.label == "dog" }!

        // cat: TP=2, FP=1, FN=0 → P=2/3, R=1.0
        XCTAssertEqual(catMetrics.truePositives, 2)
        XCTAssertEqual(catMetrics.falsePositives, 1)
        XCTAssertEqual(catMetrics.falseNegatives, 0)
        XCTAssertEqual(catMetrics.precision, 2.0 / 3.0, accuracy: 0.001)
        XCTAssertEqual(catMetrics.recall, 1.0)

        // dog: TP=0, FP=0, FN=1 → P=0, R=0
        XCTAssertEqual(dogMetrics.truePositives, 0)
        XCTAssertEqual(dogMetrics.falseNegatives, 1)
        XCTAssertEqual(dogMetrics.precision, 0.0)
        XCTAssertEqual(dogMetrics.recall, 0.0)

        XCTAssertEqual(output.accuracy, 2.0 / 3.0, accuracy: 0.001)
    }

    // MARK: - P90Calculator

    func test_p90_sorted() {
        let values = Array(1...10).map(Double.init)
        let p90 = P90Calculator.p90(values)
        // numpy.percentile([1..10], 90) = 9.1
        XCTAssertEqual(p90, 9.1, accuracy: 0.01)
    }

    func test_p90_empty() {
        XCTAssertEqual(P90Calculator.p90([]), 0.0)
    }

    func test_mean() {
        XCTAssertEqual(P90Calculator.mean([1, 2, 3, 4, 5]), 3.0)
        XCTAssertEqual(P90Calculator.mean([]), 0.0)
    }

    func test_standardDeviation() {
        // numpy.std([2,4,4,4,5,5,7,9]) = 2.0
        let values: [Double] = [2, 4, 4, 4, 5, 5, 7, 9]
        XCTAssertEqual(P90Calculator.standardDeviation(values), 2.0, accuracy: 0.001)
    }

    // MARK: - LatencyMeasurer

    func test_latencyMeasurer_returnsResult() async throws {
        let (result, latencyMs) = await LatencyMeasurer.measure {
            "hello"
        }
        XCTAssertEqual(result, "hello")
        XCTAssertGreaterThanOrEqual(latencyMs, 0.0)
    }

    func test_latencyMeasurer_into() async throws {
        var latencyMs: Double = 0
        let result = await LatencyMeasurer.measure(into: &latencyMs) {
            42
        }
        XCTAssertEqual(result, 42)
        XCTAssertGreaterThanOrEqual(latencyMs, 0.0)
    }
}
