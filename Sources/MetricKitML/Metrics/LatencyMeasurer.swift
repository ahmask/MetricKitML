// MetricKitML — all processing is on-device. No data leaves the device.
//
// LatencyMeasurer.swift
// MetricKitML/Metrics
//
// Measures wall-clock latency for async evaluation steps.

import Foundation

/// Measures wall-clock latency for an async operation and returns both the
/// result and the elapsed time in milliseconds.
///
/// Usage:
/// ```swift
/// let (result, latencyMs) = await LatencyMeasurer.measure {
///     try await myModel.predict(input)
/// }
/// ```
public enum LatencyMeasurer {

    /// Run `operation` and return its result paired with elapsed time in milliseconds.
    ///
    /// Uses `CFAbsoluteTimeGetCurrent()` — sub-millisecond precision, on-device only.
    public static func measure<T: Sendable>(
        operation: @Sendable () async throws -> T
    ) async rethrows -> (result: T, latencyMs: Double) {
        let start = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
        return (result, elapsed)
    }

    /// Run `operation`, return its result, and record the latency into the provided binding.
    public static func measure<T: Sendable>(
        into latencyMs: inout Double,
        operation: @Sendable () async throws -> T
    ) async rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        latencyMs = (CFAbsoluteTimeGetCurrent() - start) * 1000
        return result
    }
}
