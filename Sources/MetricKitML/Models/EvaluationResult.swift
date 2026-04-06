// MetricKitML — all processing is on-device. No data leaves the device.
//
// EvaluationResult.swift
// MetricKitML/Models
//
// Raw per-case result produced by an EvaluationRunner.
// Fields cover what the existing on-device projects compute: classification,
// similarity scoring (Jaccard / position), and LLM format validation.

import Foundation

/// Raw outcome for a single evaluation test case.
///
/// All fields that are not applicable to a given feature should be left `nil` /
/// default. The `EvaluationReporter` only uses the fields relevant to its
/// feature when computing aggregate metrics.
public struct EvaluationResult: Sendable {

    // MARK: - Required

    /// Stable identifier matching `EvaluationCase.id`.
    public let id: String

    /// Whether this case is considered a pass.
    ///
    /// - Classification: `predicted == expected`
    /// - Similarity: `score >= 1.0` (exact Jaccard match)
    /// - Validation: LLM format check returned "correct format"
    public let isCorrect: Bool

    /// End-to-end latency for this case in milliseconds.
    public let latencyMs: Double

    // MARK: - Classification (FeedbackClassification)

    /// The label produced by the model. `nil` for non-classification features.
    public let predictedLabel: String?

    /// The ground-truth label. `nil` for non-classification features.
    public let expectedLabel: String?

    // MARK: - Similarity (TopicFinder)

    /// Primary similarity score (Jaccard correctness). `nil` for non-similarity features.
    public let score: Double?

    /// Secondary similarity score (position relevance). `nil` when not applicable.
    public let secondaryScore: Double?

    // MARK: - LLM quality

    /// `true` when the model returned an output outside the valid label vocabulary.
    /// Only meaningful for LLM-based classification paths.
    public let hallucinationFlag: Bool

    // MARK: - Error

    /// Non-nil when this case failed with an error and the result is unreliable.
    public let error: String?

    // MARK: - Init

    public init(
        id: String,
        isCorrect: Bool,
        latencyMs: Double,
        predictedLabel: String? = nil,
        expectedLabel: String? = nil,
        score: Double? = nil,
        secondaryScore: Double? = nil,
        hallucinationFlag: Bool = false,
        error: String? = nil
    ) {
        self.id = id
        self.isCorrect = isCorrect
        self.latencyMs = latencyMs
        self.predictedLabel = predictedLabel
        self.expectedLabel = expectedLabel
        self.score = score
        self.secondaryScore = secondaryScore
        self.hallucinationFlag = hallucinationFlag
        self.error = error
    }
}
