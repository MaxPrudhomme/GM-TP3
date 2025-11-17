//
//  Sphere.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import simd

class Sphere: Mesh {
    var centerPoint: SIMD3<Float>
    var radius: Float

    init(center: SIMD3<Float> = .zero, radius: Float = 0.5) {
        self.centerPoint = center
        self.radius = radius / 2
        super.init()
    }

    override func intersects(voxel: Voxel) -> Bool {
        let half = SIMD3<Float>(repeating: voxel.size * 0.5)
        let vMin = voxel.center - half
        let vMax = voxel.center + half

        var distSq: Float = 0.0
        for i in 0..<3 {
            let c = centerPoint[i]
            if c < vMin[i] { distSq += (vMin[i] - c) * (vMin[i] - c) }
            else if c > vMax[i] { distSq += (c - vMax[i]) * (c - vMax[i]) }
        }
        return distSq <= radius * radius
    }

    override func center() {
        centerPoint = SIMD3<Float>(0.5, 0.5, 0.5)
    }

    override func normalize() {
        guard radius != 0 else { return }
        let scale = 1.0 / radius
        radius *= scale
    }
}
