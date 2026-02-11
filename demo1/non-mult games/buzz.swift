//
//  buzz.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

struct buzz_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to BUZZED! Get ready for a great time by following the instructions on the cards and having a blast! To advance to the next card, effortlessly swipe and release the card in any direction. Let the fun begin!")
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

struct buzzed: View {
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
            let cardMan = bz()
            cards = cardMan.cards
            printCards()
//            let colorMan = ColorS()
//            Zolors = colorMan.colors
            color1 = Int.random(in: 0..<Zolors.count)
            color2 = Int.random(in: 0..<Zolors.count)
//            colors = [.red, .green, .blue, .purple, .pink, .brown, .yellow, .orange, .white]
        }
    }

    
    func printCards(){
        print(cards)
    }
}


struct Buzz_Previews: PreviewProvider {
    static var previews: some View{
//    var some body{
        buzzed()
    }
}
