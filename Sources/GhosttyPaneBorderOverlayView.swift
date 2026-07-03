import AppKit
import QuartzCore

final class GhosttyPaneBorderOverlayView: NSView {
    private enum Metrics {
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 1
        static let cornerRadius: CGFloat = 8
    }

    private let borderLayer = CAShapeLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.masksToBounds = false
        autoresizingMask = [.width, .height]
        borderLayer.fillColor = NSColor.clear.cgColor
        borderLayer.lineWidth = Metrics.lineWidth
        borderLayer.lineJoin = .round
        borderLayer.lineCap = .round
        borderLayer.opacity = 0
        layer?.addSublayer(borderLayer)
        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        updatePath()
    }

    func setBorder(color: NSColor?, visible: Bool) {
        let shouldShow = visible && color != nil
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        borderLayer.strokeColor = color?.cgColor
        borderLayer.opacity = shouldShow ? 1 : 0
        isHidden = !shouldShow
        updatePath()
        CATransaction.commit()
    }

    private func updatePath() {
        let rect = bounds.insetBy(dx: Metrics.inset, dy: Metrics.inset)
        borderLayer.frame = bounds
        borderLayer.path = CGPath(
            roundedRect: rect,
            cornerWidth: Metrics.cornerRadius,
            cornerHeight: Metrics.cornerRadius,
            transform: nil
        )
    }
}
