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
    let sphere = Sphere(radius: 1)
    sphere.center()
    
    let volume = Volume(subdivisions: subdivisions, meshes: [sphere])
    
    volume.render()
    
    let mesh = Mesh(vertices: volume.vertices, indices: volume.indices)
    mesh.makeNormals()
    
    return mesh.makeNode()
}
