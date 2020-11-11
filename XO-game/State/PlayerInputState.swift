//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 11/2/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class PlayerInputState: GameState {
    
    let player: Player
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
      
        guard let gameboardView = gameboardView, gameboardView.canPlaceMarkView(at: position) else { return }
        
        gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype!.copy(), at: position)
        isCompleted = true
    }
}
