//
//  Stopwatch.swift
//
//  Copyright 2018-2021 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import Foundation



/// `Stopwatch` keeps track of the delta in foreground time between start and stop signals.

@objc(MPStopwatch)
public final class Stopwatch: NSObject {

    private var timer: ResumableTimer?
    /// Duration of stopwatch in seconds.
    private var duration: TimeInterval = 0.0

    /// Flag indicating that the stopwatch is currently running and tracking foreground duration.
    @objc
    public var isRunning: Bool {
        return timer != nil
    }

    // MARK: - Initialization

    /// Start the timer and start counting duration at 0.1s interval.
    @objc
    public func start() {
        // Stopwatch is running; do nothing.
        if timer != nil {
            return
        }

        // Reset internal state and spin up a new timer.
        duration = 0.0

        timer = ResumableTimer(interval: Constants.stopwatchStep, repeats: true, runLoopMode: .common, closure: { [weak self] _ in
            self?.duration += Constants.stopwatchStep
        })

        // Start the countup timer.
        timer?.scheduleNow();
    }

    /// Stop the stopwatch and return duration in seconds.
    @objc
    public func stop() -> TimeInterval {
        // Stopwatch not running; return 0.
        if timer == nil {
            return 0.0
        }

        // Stop and kill the internal timer.
        timer?.pause()
        timer?.invalidate()
        timer = nil

        return duration
    }
}

private extension Stopwatch {
    struct Constants {
        // 100ms interval
        static let stopwatchStep: TimeInterval = 0.1
    }
}
