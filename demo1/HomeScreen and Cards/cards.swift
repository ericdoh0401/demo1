//
//  cards.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI
import UIKit

struct Card: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
    
    static var data: [Card] {
            [
                Card(name: "Higher or Lower?", color: .red),
                Card(name: "Kings Cup", color: .orange),
                Card(name: "Dice Game", color: .yellow),
                Card(name: "BUZZED!", color: Color(UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1))),
                Card(name: "Superlatives", color: .cyan),
                Card(name: "Ultimate Pangea", color: .indigo),
                Card(name: "Titanic", color: .brown),
                Card(name: "Coin Flip", color: .blue)
            ]
        }
}

//struct OffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CupShape: Shape {
    let cupWidth: CGFloat
    let cupTopWidth: CGFloat

    init(cupWidth: CGFloat, cupTopWidth: CGFloat) {
        self.cupWidth = cupWidth
        self.cupTopWidth = cupTopWidth
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX - cupWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - cupTopWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + cupTopWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + cupWidth / 2, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

extension Color {
    func adjustBrightness(by factor: CGFloat) -> Color {
        guard let uiColor = UIColor(self).adjusted(by: factor) else {
            return self
        }

        return Color(uiColor)
    }
}

// Extension to adjust brightness for UIColor
extension UIColor {
    func adjusted(by factor: CGFloat) -> UIColor? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(
                hue: hue,
                saturation: saturation,
                brightness: min(1.0, brightness * factor),
                alpha: alpha
            )
        }

        return nil
    }
}

public struct CardManager {
    public var cards: [String] = []

    public init() {
        initializeCards()
    }

    public mutating func initializeCards() {
        let types: [String] = ["_of_hearts", "_of_spades", "_of_clubs", "_of_diamonds"]

        for number in 2...14 {
            for type in types {
                let card = "\(number)\(type)"
                cards.append(card)
            }
        }

        cards.shuffle()
    }
}

enum ActionType {
    case higher, lower, equal
}


public struct supers{
    public var cards: [String] = []
    
    public init(){
        initializeCards()
    }
    
    public mutating func initializeCards(){
        cards = ["Is obsessed with their butt",
                 "Is up at 7 A.M. on a Saturday",
                "Should be in prison",
                "Say that music festival was life changing",
                "Will drive 3+ hours in hopes of hooking up",
                "Always wants to play stupid card games",
                "Total flirt",
                "Will find a reason to take their shirt off",
                "Was a fat kid",
                "Is a fatass",
                "Want to be exclusive after first date",
                "Gets bruises and has no idea why",
                "Wouldn't go out if they didn't have to get up",
                "Will do anything for money",
                "Makes bed before going out 'just in case'",
                "Always tells the same damn story",
                "Would take the last parachute",
                "Risks life for selfie",
                "Should have been a communication major",
                "Offers to host super bowl party and doesn't show up",
                "Could pass for a homeless person",
                "Cant drive for shit",
                "Be the first to have children",
                "Move to another country",
                "To have tried the greatest number of different wines",
                "Start dancing when drunk",
                "Pole dance when drunk",
                "Be the best kisser",
                "Build the biggest house",
                "Marry a rock star",
                "Become president someday",
                "Be drunkest at one of our weddings",
                "Appear on What not to Wear",
                "Sleep through an earthquake",
                "Steal someone else's food",
                "Rob an ice cream truck while pregnant",
                "Sneak alcohol to work",
                "Most unique",
                "Flirt with a waitress or cashier",
                "Pee their pants",
                "Become an actress",
                "Hug strangers when they're drunk",
                "Have a drink named after them",
                "Least likely to spill their drink",
                "Most Likely to Spill Their Drink on Themselves",
                "Least Likely to Remember the Rules",
                "Most Likely to Hit on the Bartender",
                "Least Likely to Pass a Sobriety Test",
                "Most Likely to Start a Dance-off",
                "Most Likely to Confess a Deep, Dark Secret",
                "Least Likely to Keep a Straight Face During a Drinking Challenge",
                "Most Likely to Accidentally Insult Someone",
                "Least Likely to Hold Back on Inappropriate Jokes",
                "Most Likely to Initiate a Truth or Dare Marathon",
                "Least Likely to Recognize the Morning After",
                "Most Likely to Start a Karaoke Riot",
                "Least Likely to Admit They're Drunk",
                "Least Likely to Keep Their Clothes On",
                "Least Likely to Find Their Way Home",
                "Most Likely to Tell an Embarrassing Childhood Story",
                "Least Likely to Remember Where They Left Their Phone"]
        
        cards.shuffle()
    }
}

public struct bz{
    public var cards: [String] = []
    
    public init(){
        initializeCards()
    }
    
    public mutating func initializeCards() {
        cards = ["If you have a beard, give someone a drink because they are a 12 year old",
                 "If youre drinking beer, take two sips to catch up you little bitch",
                 "Everyone Votes: Who is most likely to microwave Mac N' Cheese without water? That person must take two sips",
                 "Everyone who is left handed take a sip with your left hand.... now switch your drink to your right hand and take another sip you weirdo",
                "All people drink if you aren't drinking liquor",
                "The person after you can ask you a question. You can either answer truthfully or refuse to answer and drink.",
                "Everyone who is single drink twice for each of your 'special friends'.... it's your hands.... im talking about your hands",
                 "Flip a coin. If it's heads, you drink. If it's tails, everyone else drinks.",
                "Everyone votes on who is most likely to own ten cats.",
                "Everyone who has snuck out of the house drinks.",
                 "Pick a person to have a staring contest with. The person that loses takes two drinks.",
                 "If you've ever left your house without underwear, drink.", "If you like cottage cheese take a drink and feel bad about yourself.",
                 "Never have I ever with 3 fingers. First one out finishes their drink.",
                 "Name 5 Pokemon. If you fail, finish your drink. If you succeed, every other player must drink.", "If you have Instagrammed a picture this week, finish your drink.",
                 "RPS: Play Rock, Paper, Scissors with the person to your left. The loser must drink. One Game to Rule them all.",
                 "If there are more guys than girls playing, then all guys must drink. If there are more girls than guys playing, then girls must drink.",
                 "The person that most recently opened a beer/made a drink must drink for 5 seconds.",
                 "Every player must point at another player. The player that has the most fingers being pointed at them must finish their drink.",
                 "Drink twice if you have ever injured myself while trying to impress a girl or boy I was interested in.",
                 "Drink if you have ever taken food out of a rubbish bin and eaten it.",
                 "Drink if you have ever lied about a family member dying as an excuse to get out of doing something.",
                 "Drink for every thing you have broken something at a friend's house and then not told them.",
                 "Drinking twice if you ever changed your facebook profile for a social cause --- you didnt do anything. Im looking at you #Kony2012.",
                 "Drink 2 times if you have ever throw up in a bathroom at a party -- 4 if it was in a sink.",
                 "Everyone Vote: who is most likely to win in a fight in a bar. The winner choses two people to take a drink.",
                 "Drink if you have stolen a street sign.",
                 "Challenge a player to a thumb war. Loser drinks.",
                 "Person to your left takes a drink.",
                 "Take a drink if you have ever gone to Coachella.",
                 "The player with the largest shoe size takes a drink. Also, congrats on the huge dick.",
                 "The youngest player takes a sip. Don't blame us; blame your parents for not ****ing sooner.",
                 "The last person to go to the bathroom drinks and anyone who goes from now on.",
                 "You and a buddy take a drink.",
                 "Everyone votes on who is the biggest alcoholic. That person drinks and picks another person to drink.",
                 "All girls drink.",
                 "RPS: Play Rock Paper Scissors with the person to your left. The loser must drink. If there is an odd number of players, the person who drew the card gets a bye. Play till there is only 1 left.",
                 "All players with facial hair must drink.",
                 "The person after you can ask you a question privately. You can answer truthfully and give a drink to someone or refuse to answer and drink.",
                 "Everyone who is single drink once because you can have another drink later when you are alone.",
                 "The person who most recently used the bathroom drinks.",
                 "Flip a coin. If it's heads, you drink. IF it's tails, everyone else drink.",
                 "You drink.",
                 "Everyone who is shorter than you drink.",
                 "Choose one person to imitate. First person to guess correctly who you are imitating gets to pick two people drink.",
                 "Everyone votes on who is most likely to bitch out of a tequila shot at 3 am. That person takes 3 sips or takes a tequila shot.",
                 "Last person to stick out their tongue drinks.",
                 "Tell everyone a story, either true or false. Whoever votes wrong drinks, if everyone is correct, you must finish your entire drink.",
                 "Pick another player to marry. Every time one of you drinks, the other one must as well until it is your turn again.",
                 "Pick another player to marry. Every time one of you drinks, the other one must as well until it is your turn again.",
                 "Drink if you have locked yourself out of a house. Drink twice if you have locked yourself out twice in the same day.",
                 "If you have watched the office multiple times this week take two drinks.",
                 "Snapchat/Instagram story the person to your left and sticker-and-enlarge their face and you both take a drink.",
                 "Pick one person to spell 'supercalifragilistic' from Mary Poppins. If they spell it right everyone else takes 3 drinks. If they get it wrong, they drink.",
                 "Never Have I ever with 3 fingers. First two out finishes their drinks.",
                 "Switch drinks with the person across from you. Both of you enjoy your new drink and take a sip.",
                 "Everyone take a sip and a moment of silence for the Rwandan Genocide and every dead Tamagotchi.",
                 "RPS: Play Rock Paper Scissors with the person to your left. The loser must drink. If there is an odd number of players, the person who drew the card gets a bye. Play till there is only 1 left.",
                 "You: Pick another player to marry. Every time one of you drinks, the other one must as well until it is your turn again.",
                 "You: Pick another player to marry. Every time one of you drinks, the other one must as well until it is your turn again."]
        
        cards.shuffle()
    }
}
