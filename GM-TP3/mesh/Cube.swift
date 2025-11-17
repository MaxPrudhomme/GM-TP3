//
//  Cube.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

//
//  CubeMesh.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import SceneKit
import simd

class Cube: Mesh {

    init(size: Float = 1.0) {
        super.init()
        build(size: size)
    }

    private func build(size: Float) {
        let h = size / 2.0

        vertices = [
            SIMD3(-h, -h, -h),
            SIMD3(h, -h, -h),
            SIMD3(h, h, -h),
            SIMD3(-h, h, -h),
            SIMD3(-h, -h, h),
            SIMD3(h, -h, h),
            SIMD3(h, h, h),
            SIMD3(-h, h, h)
        ]

        indices = [
            0, 1, 2, 0, 2, 3,
            4, 6, 5, 4, 7, 6,
            0, 3, 7, 0, 7, 4,
            1, 5, 6, 1, 6, 2,
            0, 4, 5, 0, 5, 1,
            3, 2, 6, 3, 6, 7
        ]

        makeNormals()
    }
}
