//
//  Q3.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import simd
import SwiftUI
import SceneKit

func Q3(subdivisions: Int, cubeSize: Float) -> SCNNode {
    let a = Sphere(center: SIMD3<Float>(0, 0, 0), radius: 1)
    
    let b = Sphere(center: SIMD3<Float>(0.5, 0.5, 0.5), radius: 1)
    
    let volume = Volume(subdivisions: subdivisions, meshes: [a, b], mode: .intersect, cubeSize: cubeSize)
    
    volume.render()
    
    let mesh = Mesh(vertices: volume.vertices, indices: volume.indices)
    mesh.makeNormals()
    
    return mesh.makeNode()
}
