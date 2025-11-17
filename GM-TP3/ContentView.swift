//
//  ContentView.swift
//  GM-TP3
//
//  Created by Max PRUDHOMME on 17/11/2025.
//

import SwiftUI
import SceneKit
import Combine

enum Question: String, CaseIterable, Identifiable {
    case q1 = "Q1"
    var id: String { rawValue }
}


struct ContentView: View {
    @State private var selectedQuestion: Question = .q1
    @State private var selectedMesh: String = "bunny"
    @State private var showWire: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Controls
            HStack {
                Picker("", selection: $selectedQuestion) {
                    ForEach(Question.allCases) { q in
                        Text(q.rawValue).tag(q)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Toggle("Wire", isOn: $showWire)
                    .toggleStyle(.switch)
            }
            .padding(.horizontal)

            // Preview
            GeometryPreview(geometryBuilder: {
                Q1()
            }, showWire: showWire)
            .frame(minHeight: 300)
        }
    }
}

#Preview {
    ContentView()
}

