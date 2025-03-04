//
//  AvailableHapticFeedback.swift
//
//  Created by Yonat Sharon on 25.10.2018.
//

import UIKit

/// Wrapper for UIFeedbackGenerator that compiles on iOS 9
open class AvailableHapticFeedback {
    public enum Style: CaseIterable {
        case selection
        case impactLight, impactMedium, impactHeavy
        case notificationSuccess, notificationWarning, notificationError
    }

    public let style: Style

    public init(style: Style = .selection) {
        self.style = style
    }

    open func prepare() {
#if os(iOS)
        if #available(iOS 10.0, *) {
            feedbackGenerator.prepare()
        }
#endif
    }

    open func generateFeedback() {
#if os(iOS)
        if #available(iOS 10.0, *) {
            feedbackGenerator.generate(style: style)
        }
#endif
    }

    open func end() {
        _anyFeedbackGenerator = nil
    }

#if os(iOS)
    @available(iOS 10.0, *)
    var feedbackGenerator: UIFeedbackGenerator & AvailableHapticFeedbackGenerator {
        if nil == _anyFeedbackGenerator {
            createFeedbackGenerator()
        }
        // swiftlint:disable force_cast force_unwrapping
        return _anyFeedbackGenerator! as! UIFeedbackGenerator & AvailableHapticFeedbackGenerator
        // swiftlint:enable force_cast force_unwrapping
    }
#endif

    private var _anyFeedbackGenerator: Any?

    @available(iOS 10.0, *)
    private func createFeedbackGenerator() {
        #if os(iOS)
        switch style {
        case .selection:
            _anyFeedbackGenerator = UISelectionFeedbackGenerator()
        case .impactLight:
            _anyFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        case .impactMedium:
            _anyFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        case .impactHeavy:
            _anyFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        case .notificationSuccess, .notificationWarning, .notificationError:
            _anyFeedbackGenerator = UINotificationFeedbackGenerator()
        }
        #endif
    }
}

protocol AvailableHapticFeedbackGenerator {
    func generate(style: AvailableHapticFeedback.Style)
}

#if os(iOS)
@available(iOS 10.0, *)
extension UISelectionFeedbackGenerator: AvailableHapticFeedbackGenerator {
    func generate(style: AvailableHapticFeedback.Style) {
        selectionChanged()
    }
}

@available(iOS 10.0, *)
extension UIImpactFeedbackGenerator: AvailableHapticFeedbackGenerator {
    func generate(style: AvailableHapticFeedback.Style) {
        impactOccurred()
    }
}

@available(iOS 10.0, *)
extension UINotificationFeedbackGenerator: AvailableHapticFeedbackGenerator {
    func generate(style: AvailableHapticFeedback.Style) {
        let notificationFeedbackType: UINotificationFeedbackGenerator.FeedbackType
        switch style {
        case .notificationWarning:
            notificationFeedbackType = .warning
        case .notificationError:
            notificationFeedbackType = .error
        default:
            notificationFeedbackType = .success
        }
        notificationOccurred(notificationFeedbackType)
    }
}
#endif
