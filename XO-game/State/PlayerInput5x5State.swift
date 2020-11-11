//
//  PlayerInput5x5State.swift
//  XO-game
//
//  Created by Антон Васильченко on 11.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class PlayerInput5x5State: GameState {
    
    public let player: Player
    private(set) var isCompleted = false
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    private(set) var markViewPrototype: MarkView?
    
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
        guard let gameboardView = gameboardView,
              let gameboard = gameboard,
              gameboardView.canPlaceMarkView(at: position)
        else { return }
        
        isCompleted = Invoker.shared.addMoveCommand(
            Command(player: player,
                    position: position,
                    gameboard: gameboard,
                    gameboardView: gameboardView))
    }
}
