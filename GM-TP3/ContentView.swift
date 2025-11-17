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
    case q2 = "Q2"
    case q3 = "Q3"
    case q4 = "Q4"
    var id: String { rawValue }
}

struct ContentView: View {
    @State private var selectedQuestion: Question = .q4
    @State private var showWire: Bool = true
    @State private var subdivisions: Int = 8

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Controls
            HStack(spacing: 16) {
                Picker("", selection: $selectedQuestion) {
                    ForEach(Question.allCases) { q in
                        Text(q.rawValue).tag(q)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Stepper("Sub: \(subdivisions)", value: $subdivisions, in: 1...16)
                    .frame(width: 80)
                
                Divider()
                
                Toggle("Wire", isOn: $showWire)
                    .toggleStyle(.switch)
            }
            .padding(.horizontal)

            // Preview
            GeometryPreview(
                geometryBuilder: {
                    switch selectedQuestion {
                    case .q1:
                        Q1(subdivisions: subdivisions)
                    case .q2:
                        Q2(subdivisions: subdivisions)
                    case .q3:
                        Q3(subdivisions: subdivisions)
                    case .q4:
                        Q4(subdivisions: subdivisions)
                    }
                },
                showWire: showWire
            )
            .id(subdivisions * (showWire ? 1 : 1000))
            .frame(minHeight: 300)
        }
    }
}

#Preview {
    ContentView()
}
