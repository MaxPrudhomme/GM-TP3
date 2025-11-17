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
        vertices.removeAll()
        indices.removeAll()
        
        for x in 0..<subdivisions {
            for y in 0..<subdivisions {
                for z in 0..<subdivisions {
                    let center = SIMD3<Float>(
                        (Float(x) + 0.5) * factor,
                        (Float(y) + 0.5) * factor,
                        (Float(z) + 0.5) * factor
                    )
                    
                    for mesh in meshes {
                        if mesh.intersects(voxel: Voxel(center: center, size: factor)) {
                            addCube(at: center, size: factor)
                            break
                        }
                    }
                }
            }
        }
        
        guard !vertices.isEmpty else { return }
        
        let sum = vertices.reduce(SIMD3<Float>(0, 0, 0)) { $0 + $1 }
        let centroid = sum / Float(vertices.count)
        for i in 0..<vertices.count {
            vertices[i] -= centroid
        }

        let maxCoord = vertices.reduce(Float(0)) { currentMax, v in
            let vertexMax = max(abs(v.x), abs(v.y), abs(v.z))
            return max(currentMax, vertexMax)
        }
        let scale: Float = 1.0 / maxCoord
        for i in 0..<vertices.count {
            vertices[i] *= scale
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
