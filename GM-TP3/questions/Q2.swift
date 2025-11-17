//
//  Q2.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import simd
import SwiftUI
import SceneKit

func Q2(subdivisions: Int) -> SCNNode {
    let a = Sphere(center: SIMD3<Float>(0, 0, 0), radius: 1)
    
    let b = Sphere(center: SIMD3<Float>(1, 1, 1), radius: 1)
    
    let volume = Volume(subdivisions: subdivisions, meshes: [a, b])
    
    volume.render()
    
    let mesh = Mesh(vertices: volume.vertices, indices: volume.indices)
    mesh.makeNormals()
    
    return mesh.makeNode()
}
