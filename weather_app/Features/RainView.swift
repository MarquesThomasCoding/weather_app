//
//  RainView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI

struct RainView: View {
    struct Raindrop: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var speed: CGFloat
        var length: CGFloat
    }

    @State private var raindrops: [Raindrop] = []
    @State private var timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()

    var body: some View {
        Canvas { context, size in
            for drop in raindrops {
                var path = Path()
                path.move(to: CGPoint(x: drop.x, y: drop.y))
                path.addLine(to: CGPoint(x: drop.x, y: drop.y + drop.length))
                context.stroke(path, with: .color(.white.opacity(0.5)), lineWidth: 1.5)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            let screen = UIScreen.main.bounds
            raindrops = (0..<180).map { _ in
                Raindrop(
                    x: CGFloat.random(in: 0...screen.width),
                    y: CGFloat.random(in: 0...screen.height),
                    speed: CGFloat.random(in: 4...10),
                    length: CGFloat.random(in: 8...18)
                )
            }
        }
        .onReceive(timer) { _ in
            let screen = UIScreen.main.bounds
            for i in raindrops.indices {
                raindrops[i].y += raindrops[i].speed
                if raindrops[i].y > screen.height {
                    raindrops[i].y = -raindrops[i].length
                    raindrops[i].x = CGFloat.random(in: 0...screen.width)
                }
            }
        }
        .allowsHitTesting(false)
    }
}


#Preview {
    RainView()
}
