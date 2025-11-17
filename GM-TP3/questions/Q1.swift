//
//  Q1.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import simd
import SwiftUI
import SceneKit

func Q1() -> SCNNode {
    let cube = Cube(size: 1)
    cube.center()
    cube.normalize()
    let volume = Volume(subdivisions: 1, meshes: [cube])
    
    volume.render()
    
    let mesh = Mesh(vertices: volume.vertices, indices: volume.indices)
    mesh.makeNormals()
    
    return mesh.makeNode()
}
