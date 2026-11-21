import AppKit

/// The little snowplow tractor that clears the drift off the screen bottom, drawn side on and facing right: the
/// renderer mirrors it by flipping the quad when it drives the other way.
enum Tractor {
    /// The drawing's size in its own units; its y runs down.
    static let size = CGSize(width: 124, height: 82)
    static let aspect = Float(size.height / size.width)
    /// How wide it is drawn on screen, in points. The blade reaches a little past this.
    static let width: Float = 86
    static let height: Float = width * aspect
    /// Where the blade's cutting edge is, as a share of the width right of the middle.
    static let blade: Float = 0.46
    /// The wheels' centres, as shares of the width from the middle, for the slope it rides on.
    static let wheels: (rear: Float, front: Float) = (-0.3, 0.16)

    /// Drawn `scale` pixels per unit into premultiplied BGRA.
    static func draw(scale: CGFloat) -> CGContext? {
        let width = Int(size.width * scale), height = Int(size.height * scale)
        guard let context = CGContext(
            data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        ) else { return nil }
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: scale, y: -scale)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        drawBody(in: context)
        return context
    }

    private static func drawBody(in context: CGContext) {
        // The blade first, so the bonnet laps over its arm.
        let arm = CGMutablePath()
        arm.move(to: CGPoint(x: 74, y: 54))
        arm.addLine(to: CGPoint(x: 99, y: 50))
        arm.addLine(to: CGPoint(x: 99, y: 56))
        arm.addLine(to: CGPoint(x: 74, y: 60))
        arm.closeSubpath()
        context.setFillColor(color(0x4a4f57))
        context.addPath(arm)
        context.fillPath()

        let blade = CGMutablePath()
        blade.move(to: CGPoint(x: 96, y: 24))
        blade.addCurve(to: CGPoint(x: 112, y: 70), control1: CGPoint(x: 112, y: 32), control2: CGPoint(x: 115, y: 56))
        blade.addLine(to: CGPoint(x: 120, y: 72))
        blade.addLine(to: CGPoint(x: 120, y: 76))
        blade.addLine(to: CGPoint(x: 94, y: 76))
        blade.addLine(to: CGPoint(x: 94, y: 26))
        blade.closeSubpath()
        fill(blade, with: gradient([(0, 0xffb347), (0.5, 0xf08a1e), (1, 0xc96a10)]), in: context)
        context.setStrokeColor(color(0x8a4708, alpha: 0.7))
        context.setLineWidth(1.4)
        context.addPath(blade)
        context.strokePath()
        // The scraped steel edge along its foot.
        let edge = CGMutablePath()
        edge.move(to: CGPoint(x: 94, y: 70))
        edge.addLine(to: CGPoint(x: 120, y: 73))
        context.setStrokeColor(color(0xdfe4ea))
        context.setLineWidth(3)
        context.addPath(edge)
        context.strokePath()

        // The exhaust pipe and its puff of smoke.
        let pipe = CGMutablePath()
        pipe.addRect(CGRect(x: 58, y: 14, width: 5, height: 22))
        context.setFillColor(color(0x3b4049))
        context.addPath(pipe)
        context.fillPath()
        context.setFillColor(color(0xd8dde4, alpha: 0.35))
        context.fillEllipse(in: CGRect(x: 54, y: 2, width: 13, height: 13))

        // The bonnet, from the cab forward to the nose.
        let bonnet = CGMutablePath()
        bonnet.move(to: CGPoint(x: 52, y: 34))
        bonnet.addLine(to: CGPoint(x: 90, y: 34))
        bonnet.addCurve(to: CGPoint(x: 94, y: 40), control1: CGPoint(x: 93, y: 34), control2: CGPoint(x: 94, y: 36))
        bonnet.addLine(to: CGPoint(x: 94, y: 56))
        bonnet.addLine(to: CGPoint(x: 52, y: 56))
        bonnet.closeSubpath()
        fill(bonnet, with: gradient([(0, 0x6fd36a), (0.55, 0x3fa83c), (1, 0x227a24)]), in: context)

        // The cab: a roof on two posts, with the glass between them.
        let cab = CGMutablePath()
        cab.move(to: CGPoint(x: 24, y: 10))
        cab.addLine(to: CGPoint(x: 58, y: 10))
        cab.addLine(to: CGPoint(x: 58, y: 16))
        cab.addLine(to: CGPoint(x: 24, y: 16))
        cab.closeSubpath()
        context.setFillColor(color(0x2e7d2b))
        context.addPath(cab)
        context.fillPath()

        context.setFillColor(color(0x9fd8ea, alpha: 0.85))
        context.fill(CGRect(x: 30, y: 16, width: 24, height: 20))
        context.setStrokeColor(color(0x1f5c1e))
        context.setLineWidth(3)
        context.stroke(CGRect(x: 30, y: 16, width: 24, height: 20))

        // The body under the cab, down to the axles.
        let body = CGMutablePath()
        body.move(to: CGPoint(x: 18, y: 34))
        body.addLine(to: CGPoint(x: 56, y: 34))
        body.addLine(to: CGPoint(x: 56, y: 62))
        body.addLine(to: CGPoint(x: 22, y: 62))
        body.addCurve(to: CGPoint(x: 18, y: 54), control1: CGPoint(x: 19, y: 62), control2: CGPoint(x: 18, y: 58))
        body.closeSubpath()
        fill(body, with: gradient([(0, 0x5cc457), (0.6, 0x349331), (1, 0x1c6a1e)]), in: context)

        // A seam along the flank, and the little round lamp on the nose.
        context.setStrokeColor(color(0x15531a, alpha: 0.5))
        context.setLineWidth(1.4)
        let seam = CGMutablePath()
        seam.move(to: CGPoint(x: 20, y: 44))
        seam.addLine(to: CGPoint(x: 92, y: 44))
        context.addPath(seam)
        context.strokePath()
        context.setFillColor(color(0xffe9a8))
        context.fillEllipse(in: CGRect(x: 85, y: 37, width: 7, height: 7))

        wheel(at: CGPoint(x: 29, y: 56), radius: 23, hub: 9, in: context)
        wheel(at: CGPoint(x: 78, y: 63), radius: 16, hub: 6, in: context)
    }

    /// A tyre with a tread of lugs around it and a hub at the middle.
    private static func wheel(at center: CGPoint, radius: CGFloat, hub: CGFloat, in context: CGContext) {
        context.setFillColor(color(0x23262c))
        context.fillEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        context.setStrokeColor(color(0x12141a))
        context.setLineWidth(radius * 0.22)
        let lugs = CGMutablePath()
        let count = 12
        for k in 0..<count {
            let a = CGFloat(k) / CGFloat(count) * 2 * .pi
            let inner = radius * 0.74, outer = radius * 0.99
            lugs.move(to: CGPoint(x: center.x + cos(a) * inner, y: center.y + sin(a) * inner))
            lugs.addLine(to: CGPoint(x: center.x + cos(a) * outer, y: center.y + sin(a) * outer))
        }
        context.addPath(lugs)
        context.strokePath()
        context.setFillColor(color(0xd9dee6))
        context.fillEllipse(in: CGRect(x: center.x - hub, y: center.y - hub, width: hub * 2, height: hub * 2))
        context.setFillColor(color(0x8f98a6))
        context.fillEllipse(in: CGRect(x: center.x - hub * 0.35, y: center.y - hub * 0.35, width: hub * 0.7, height: hub * 0.7))
    }

    /// Fills `path` with a linear gradient down over its bounds.
    private static func fill(_ path: CGPath, with gradient: CGGradient, in context: CGContext) {
        let box = path.boundingBoxOfPath
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: box.minX, y: box.minY),
            end: CGPoint(x: box.minX, y: box.maxY),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        context.restoreGState()
    }

    private static func gradient(_ stops: [(location: CGFloat, hex: Int)]) -> CGGradient {
        CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: stops.map { color($0.hex) } as CFArray, locations: stops.map(\.location))!
    }

    private static func color(_ hex: Int, alpha: CGFloat = 1) -> CGColor {
        CGColor(srgbRed: CGFloat(hex >> 16 & 0xff) / 255, green: CGFloat(hex >> 8 & 0xff) / 255, blue: CGFloat(hex & 0xff) / 255, alpha: alpha)
    }
}
