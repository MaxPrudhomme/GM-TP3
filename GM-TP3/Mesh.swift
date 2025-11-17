//
//  Mesh.swift
//  GM-TP2
//
//  Created by Max PRUDHOMME on 03/11/2025.
//


//
//  Mesh.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import SceneKit
import SwiftUI
import simd

class Mesh {
    static var renderWire: Bool = true

    var vertices: [SIMD3<Float>]
    var indices: [UInt16]
    var normals: [SIMD3<Float>] = []

    init(vertices: [SIMD3<Float>] = [], indices: [UInt16] = []) {
        self.vertices = vertices
        self.indices = indices
    }
    
    func makeNode() -> SCNNode {
        let vsrc = SCNGeometrySource(
            vertices: vertices.map { SCNVector3($0.x, $0.y, $0.z) }
        )
        let nrm = normals.isEmpty
            ? Array(repeating: SIMD3<Float>(0, 0, 1), count: vertices.count)
            : normals
        let nsrc = SCNGeometrySource(
            normals: nrm.map { SCNVector3($0.x, $0.y, $0.z) }
        )

        let indicesData = indices.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }

        let elem = SCNGeometryElement(
            data: indicesData,
            primitiveType: .triangles,
            primitiveCount: indices.count / 3,
            bytesPerIndex: MemoryLayout<UInt16>.size
        )

        // constant-shaded fill
        let solid = SCNGeometry(sources: [vsrc, nsrc], elements: [elem])
        let fillMat = SCNMaterial()
        fillMat.lightingModel = .constant
        #if os(macOS)
        fillMat.diffuse.contents = NSColor.white
        #endif
        fillMat.isDoubleSided = true  // fixes inside-out appearance
        solid.materials = [fillMat]

        // optional wire overlay
        let wire = SCNGeometry(sources: [vsrc, nsrc], elements: [elem])
        let wireMat = SCNMaterial()
        wireMat.fillMode = .lines
        wireMat.lightingModel = .constant
        #if os(macOS)
        wireMat.diffuse.contents = NSColor.black
        #else
        wireMat.diffuse.contents = UIColor.black
        #endif
        wireMat.isDoubleSided = true
        wire.materials = [wireMat]

        let parent = SCNNode()
        parent.addChildNode(SCNNode(geometry: solid))

        if Mesh.renderWire {
            parent.addChildNode(SCNNode(geometry: wire))
        }

        return parent
    }
    
    func parse(from path: String) throws {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            var lines = content
                .split(whereSeparator: \.isNewline)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && !$0.hasPrefix("#") }

            guard lines.first == "OFF" else { throw NSError(domain: "OFFParser", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing OFF header"]) }
            lines.removeFirst()
            
            let counts = lines.removeFirst().split(separator: " ").compactMap { Int($0) }
            guard counts.count >= 3 else { throw NSError(domain: "OFFParser", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid counts line"]) }

            let vertexCount = counts[0]
            let faceCount = counts[1]

            vertices.removeAll()
            for i in 0..<vertexCount {
                let parts = lines.removeFirst().split(separator: " ").compactMap { Float($0) }
                guard parts.count == 3 else {
                    throw NSError(
                        domain: "OFFParser",
                        code: 3,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid vertex line \(i)"]
                    )
                }
                vertices.append(SIMD3(parts[0], parts[1], parts[2]))
            }

            indices.removeAll()
            for i in 0..<faceCount {
                let parts = lines.removeFirst().split(separator: " ").compactMap { Int($0) }
                guard parts.count >= 4 else {
                    throw NSError(
                        domain: "OFFParser",
                        code: 4,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid face line \(i)"]
                    )
                }
                let faceIndices = Array(parts[1...])
                for idx in faceIndices {
                    indices.append(UInt16(idx))
                }
            }

            normals = Array(repeating: SIMD3<Float>(0, 0, 1), count: vertices.count)
        }
    
    func load(named name: String, withExtension ext: String = "off") throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            throw NSError(domain: "Mesh", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Failed to find \(name).\(ext) in bundle."
            ])
        }
        try parse(from: url.path)
    }
    
    func center() {
        let sum = vertices.reduce(SIMD3<Float>(0, 0, 0)) { $0 + $1 }
        let center = sum / Float(vertices.count)
        
        for i in 0..<vertices.count {
            vertices[i] -= center
        }
    }
    
    func normalize() {
        let maxCoord = vertices.reduce(Float(0)) { currentMax, vertex in
            let vertexMax = max(abs(vertex.x), abs(vertex.y), abs(vertex.z))
            return max(currentMax, vertexMax)
        }
        
        for i in 0..<vertices.count {
            let scale: Float = 1.0 / maxCoord
            vertices[i] *= scale
        }
    }
    
    func makeNormals() {
        var normalCounts = Array(repeating: 0, count: vertices.count)
        normals = Array(repeating: SIMD3<Float>(0, 0, 0), count: vertices.count)
        
        for i in stride(from: 0, to: indices.count, by: 3) {
            let ia = Int(indices[i])
            let ib = Int(indices[i + 1])
            let ic = Int(indices[i + 2])
            
            guard ia < vertices.count, ib < vertices.count, ic < vertices.count else { continue }
            
            let a = vertices[ia]
            let b = vertices[ib]
            let c = vertices[ic]
            let faceNormal = simd_normalize(simd_cross(b - a, c - a))
            
            normals[ia] += faceNormal
            normals[ib] += faceNormal
            normals[ic] += faceNormal
            normalCounts[ia] += 1
            normalCounts[ib] += 1
            normalCounts[ic] += 1
        }
        
        for i in 0..<normals.count {
            if normalCounts[i] > 0 {
                normals[i] /= Float(normalCounts[i])
                normals[i] = simd_normalize(normals[i])
            }
        }
    }
    
    func export(to path: String) throws {
        var content = "OFF\n"
        content += "\(vertices.count) \(indices.count / 3) 0\n"
        
        for vertex in vertices {
            content += "\(vertex.x) \(vertex.y) \(vertex.z)\n"
        }
        
        for i in stride(from: 0, to: indices.count, by: 3) {
            let a = indices[i]
            let b = indices[i + 1]
            let c = indices[i + 2]
            content += "3 \(a) \(b) \(c)\n"
        }
        
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    func intersects(voxel: Voxel) -> Bool {
        guard !vertices.isEmpty else { return false }
        var meshMin = vertices[0]
        var meshMax = vertices[0]
        for v in vertices {
            meshMin = simd_min(meshMin, v)
            meshMax = simd_max(meshMax, v)
        }

        let half = SIMD3<Float>(repeating: voxel.size * 0.5)
        let vMin = voxel.center - half
        let vMax = voxel.center + half

        let overlap =
            meshMin.x <= vMax.x && meshMax.x >= vMin.x &&
            meshMin.y <= vMax.y && meshMax.y >= vMin.y &&
            meshMin.z <= vMax.z && meshMax.z >= vMin.z
            
        return overlap
    }
}

