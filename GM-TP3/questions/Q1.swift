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
    let cube = Cube(size: 1.0)

    cube.center()
    cube.normalize()
    
    return cube.makeNode()}
