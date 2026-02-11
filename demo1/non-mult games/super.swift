//
//  super.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

struct super_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to Superlatives! Get ready for a night of laughter and revelations with friends. This interactive game is designed to bring you closer while having a blast. Discover unexpected superlatives, share laughs, and maybe learn a thing or two about each other. Let the good times roll!\n\nHow to play:\n1. Each card features a superlative (e.g., 'Least likely to...' or 'Most likely to...').\n\n2. Players point at the person they believe best fits the superlative on the card.\n\n3. The person with the most points drinks as a penalty.\n\n4. Players can choose to make an X with their arms instead of pointing if they believe they are likely to be chosen.\n\n5. If someone makes an X but isn't selected by others, they face a penalty and must drink.\n\nEnjoy the game responsibly, and have fun exploring the various superlatives with your friends! To move on to the next card, simply click, drag, and let go of the current card.")
                            .foregroundColor(.white)
                            .font(.system(size:15))
                            .padding()
                    }
                )
                .frame(width: 350, height: 600)
                .foregroundColor(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            Spacer()
                .frame(height: 75)
        }
    }
}

struct superlatives: View {
    @State private var cards: [String] = []
    @State var isDragging = false
    @State var position = CGSize.zero
    @State var cardNum: Int = 0
    @State var stopWatch: Int = 0
    @State private var timer: Timer?
    @State private var isDelayCompleted = false
    @State private var Zolors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal]
//    @State var Zolors: [Color] = []
    @State private var color1: Int = -1
    @State private var color2: Int = -1
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Zolors.indices.contains(color1) ? Zolors[color1] : .white,
                Zolors.indices.contains(color2) ? Zolors[color2] : .white,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            if cardNum < cards.count {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .overlay(
                        Text(cards[cardNum])
                            .foregroundColor(.white)
                            .font(.system(size:30))
                            .padding()
                    )
                    .frame(width: 300, height: 500)
                    .offset(x: position.width, y: position.height)
                    .foregroundColor(.black)
                    .animation(.linear)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                position = value.translation
                                isDragging = true
                                isDelayCompleted = false
                            })
                            .onEnded({ value in
                                // would it be possible to check and see the
                                // amount at which position has changed?
                                position = .zero
                                isDragging = false
                                stopWatch = 0
                                Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                                    if !isDelayCompleted {
                                        cardNum += 1
                                        isDelayCompleted = true
                                        color1 = Int.random(in: 0..<Zolors.count)
                                        color2 = Int.random(in: 0..<Zolors.count)
                                    }
                                }
                            })
                    )
            }
            else {
                Image("complete")
                    .resizable()
                    .frame(width: 300, height: 300)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        .onAppear() {
            let cardMan = supers()
            cards = cardMan.cards
//            let colorMan = ColorS()
//            Zolors = colorMan.colors
            color1 = Int.random(in: 0..<Zolors.count)
            color2 = Int.random(in: 0..<Zolors.count)
//            colors = [.red, .green, .blue, .purple, .pink, .brown, .yellow, .orange, .white]
        }
    }
}
