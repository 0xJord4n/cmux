import AppKit
import CmuxFoundation
import CmuxSettings
import Foundation

enum PaneAppearanceSettings {
    static let didChangeNotification = Notification.Name("PaneAppearanceSettings.didChange")

    private static let app = AppCatalogSection()

    static var paneBorderColorKey: String { app.paneBorderColorHex.userDefaultsKey }
    static var activePaneBorderColorKey: String { app.activePaneBorderColorHex.userDefaultsKey }
    static var unfocusedPaneOpacityKey: String { app.unfocusedPaneOpacity.userDefaultsKey }

    static func paneBorderColorHex(defaults: UserDefaults = .standard) -> String? {
        normalizedHex(defaults.string(forKey: paneBorderColorKey))
    }

    static func activePaneBorderColor(defaults: UserDefaults = .standard) -> NSColor? {
        normalizedHex(defaults.string(forKey: activePaneBorderColorKey)).flatMap(NSColor.init(hex:))
    }

    static func unfocusedPaneOpacityOverride(defaults: UserDefaults = .standard) -> Double? {
        guard let number = defaults.object(forKey: unfocusedPaneOpacityKey) as? NSNumber else { return nil }
        return clampOpacity(number.doubleValue)
    }

    static func clampOpacity(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }

    static func notifyDidChange(notificationCenter: NotificationCenter = .default) {
        notificationCenter.post(name: didChangeNotification, object: nil)
    }

    private static func normalizedHex(_ raw: String?) -> String? {
        guard let raw,
              let normalized = WorkspaceTabColorSettings.normalizedHex(raw),
              !normalized.isEmpty else {
            return nil
        }
        return normalized
    }
}
