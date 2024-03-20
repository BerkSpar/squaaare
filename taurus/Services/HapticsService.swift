//
//  HapticService.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import UIKit

/// A service for playing haptic feedback.
///
/// This class provides utility functions for triggering haptic feedback on supported devices.
/// It encapsulates the system's haptic feedback mechanisms to provide an easier interface for playing
/// different feedback styles and types.
class HapticsService {

    /// The shared singleton instance of `HapticsService`.
    static let shared = HapticsService()
    
    /// A private initializer to ensure the singleton pattern is adhered to.
    private init() {}

    /// Plays an impact feedback based on the provided style.
    ///
    /// This function triggers a haptic feedback on the device that gives the sensation of a physical impact.
    ///
    /// - Parameter feedbackStyle: The style of impact feedback. The styles determine the intensity of the feedback.
    ///                            For example: `.light`, `.medium`, `.heavy`.
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    /// Plays a notification feedback based on the provided type.
    ///
    /// This function triggers a haptic feedback on the device that corresponds to a notification type.
    ///
    /// - Parameter feedbackType: The type of notification feedback. The types help differentiate between feedback sensations.
    ///                           For example: `.success`, `.warning`, `.error`.
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
