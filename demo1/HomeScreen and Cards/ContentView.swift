////
////  ContentView.swift
////  demo
////
////  Created by Eric Oh on 1/16/24.
////
////
//

// figure out how to take a screenshot of a device with
// a different iOS. "OS Version no runtime."

// crop the image for iPhone


// currently, we know that the NavigationBlock is handled differently on an iPad.

import SwiftUI
import UIKit

struct ContentView: View {
    @AppStorage("yourName") var yourName = ""
    @EnvironmentObject var game: GameService
    @State private var offset: CGFloat = 0
    @State private var offset1: CGFloat = 0
    @State private var threshold: Bool = false
    @State private var showGradient = false
    @State private var blockPosition: CGSize = .zero
    @State private var flickerToggle: Bool = true
    
    init(yourName: String){
        self.yourName = yourName
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(.black)
                        .ignoresSafeArea()
                    
                    if threshold {
                        Sample(yourName: self.yourName)
                            .opacity(showGradient ? 1.0 : 0.0)
                    }
                    else {
                        LinearGradient(gradient: Gradient(colors: [.purple.adjustBrightness(by: 0.5), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()
                            .overlay(
                                VStack {
                                    Spacer().frame(height: geometry.size.height * 0.4)
                                    Image(systemName:"gamecontroller.fill")
                                        .resizable()
                                        .frame(width: 70, height: 50)
                                    Spacer().frame(height: geometry.size.height * 0.02)
                                    Text("Welcome!")
                                    Spacer().frame(height: geometry.size.height * 0.4)
                                    Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                                        .resizable()
                                        .frame(width: 60, height: 50)
                                        .padding(.leading, 20.0)
                                        .opacity(flickerToggle ? 0.5 : 1)
                                        .onAppear {
                                            startFlickering()
                                        }
                                    Text("Click & Drag")
                                }
                            )
                            .foregroundColor(.white)
                            .offset(blockPosition)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let translation = value.translation
                                        if translation.height < -500 {
                                            withAnimation(.spring()) {
                                                blockPosition.height = -500
                                                threshold = true
                                            }
                                        } else {
                                            blockPosition.height = translation.height
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            if !threshold {
                                                blockPosition = .zero
                                            }
                                            else {
                                                withAnimation(.linear(duration: 1.2)) {
                                                    showGradient = true
                                                }
                                            }
                                        }
                                    }
                            )
                            .offset(y: offset)
                    }
                }
            }
        }
    }
    
    private func startFlickering() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
    
}


struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView(yourName: "Sample1")
            .environmentObject(GameService())
    }
}


struct Instruction: Hashable {
    let name: String
    let imageName: String
    let color: Color
}


struct Game: Hashable{
    let name: String
    let imageName: String
    let color: Color
    let index: Int
    let dimX: CGFloat
    let dimY: CGFloat
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
}
