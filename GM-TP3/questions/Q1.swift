//
//  Q1.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import simd
import SwiftUI
import SceneKit

func Q1(subdivisions: Int, cubeSize: Float) -> SCNNode {
    let sphere = Sphere(radius: 1)
    sphere.center()
    
    let volume = Volume(subdivisions: subdivisions, meshes: [sphere], cubeSize: cubeSize)
    
    volume.render()
    
    let mesh = Mesh(vertices: volume.vertices, indices: volume.indices)
    mesh.makeNormals()
    
    return mesh.makeNode()
}
