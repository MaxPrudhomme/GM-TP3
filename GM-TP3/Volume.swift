//
//  Volume.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

class Volume {
    var subdivisions: Int
    var factor: Float
    var meshes: [Mesh]
    
    var vertices: [SIMD3<Float>] = []
    var indices: [UInt16] = []
    
    init(subdivisions: Int = 1, meshes: [Mesh] = []) {
        self.subdivisions = subdivisions
        self.meshes = meshes
        
        self.factor = 1.0 / Float(subdivisions)
    }
    
    func render() {
        for x in 0...subdivisions {
            for y in 0...subdivisions {
                for z in 0...subdivisions {
                    let center = SIMD3<Float>(Float(x) * factor, Float(y) * factor, Float(z) * factor)
                    
                    for mesh in meshes {
                        if mesh.intersects(voxel: Voxel(center: center, size: factor)) {
                            addCube(at: center, size: factor)
                        }
                    }
                }

            }
        }
    }
    
    private func addCube(at center: SIMD3<Float>, size: Float) {
        let cubeVertices: [SIMD3<Float>] = [
            SIMD3(-0.5, -0.5, -0.5),
            SIMD3( 0.5, -0.5, -0.5),
            SIMD3( 0.5,  0.5, -0.5),
            SIMD3(-0.5,  0.5, -0.5),
            SIMD3(-0.5, -0.5,  0.5),
            SIMD3( 0.5, -0.5,  0.5),
            SIMD3( 0.5,  0.5,  0.5),
            SIMD3(-0.5,  0.5,  0.5)
        ]

        let cubeIndices: [UInt16] = [
            0, 1, 2,  0, 2, 3,
            4, 6, 5,  4, 7, 6,
            3, 2, 6,  3, 6, 7,
            0, 5, 1,  0, 4, 5,
            0, 3, 7,  0, 7, 4,
            1, 5, 6,  1, 6, 2
        ]
        
        let baseIndex = UInt16(vertices.count)
        let transformed = cubeVertices.map { center + $0 * size }
        vertices.append(contentsOf: transformed)

        indices.append(contentsOf: cubeIndices.map { $0 + baseIndex })
    }
}

struct Voxel {
    let center: SIMD3<Float>
    let size: Float
}
