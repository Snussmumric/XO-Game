//
//  ComputerState.swift
//  XO-game
//
//  Created by Антон Васильченко on 11.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class ComputerState: GameState {
    
    public let player: Player
    var isCompleted = false
    
    private(set) var gameViewController: GameViewController?
    private(set) var gameboard: Gameboard?
    private(set) var gameboardView: GameboardView?
    
    var markViewPrototype: MarkView?
    
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView
    ) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func begin() {
        switch self.player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
        markViewPrototype = player.markViewPrototype
    }
    
    func addMark(at position: GameboardPosition) {
        addRandomPosition()
    }
    
    func addRandomPosition() {
        guard let gameboardView = gameboardView, let gameboard = gameboard, gameboard.isSpaceAvailable() else { return }
        var randomColumn = Int.random(in: 0 ..< GameboardSize.columns)
        var randomRow = Int.random(in: 0 ..< GameboardSize.rows)
        
        var position = GameboardPosition(column: randomColumn, row: randomRow)
        
        while !gameboardView.canPlaceMarkView(at: position) {
             randomColumn = Int.random(in: 0 ..< GameboardSize.columns)
             randomRow = Int.random(in: 0 ..< GameboardSize.rows)
             position = GameboardPosition(column: randomColumn, row: randomRow)
        }
        gameboard.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype!.copy(), at: position)
        isCompleted = true
    }
}

