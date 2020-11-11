//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    var mode: GameMode = .normal
    
    
    @IBOutlet weak var gameModeSelectSegment: UISegmentedControl!
    @IBAction func gameModeSelectPressed(_ sender: UISegmentedControl) {
        switch gameModeSelectSegment.selectedSegmentIndex {
        case 0:
            mode = .normal
            restart()
        case 1:
            mode = .computer
            restart()
        case 2:
            mode = .severalMoves
            restart()
        default:
            break
        }
        
    }
    
    private let gameboard = Gameboard()
    private lazy var referee = Referee(gameboard: gameboard)
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.setNextState()
            }
        }
    }
    
    func setFirstState() {
        if mode == .severalMoves {
            currentState = PlayerInput5x5State(player: .first,
                                               gameViewController: self,
                                               gameboard: gameboard,
                                               gameboardView: gameboardView)
            
        } else {
            currentState = PlayerInputState(player: .first,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        }
    }
    
    func setNextState() {
        if referee.determineEndTheGame(mode: mode) {
            currentState = ExecutionState(gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
            return
        }
        
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
            
        }
        
        if !gameboard.isSpaceAvailable() {
            currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }
        
        switch mode {
        case .computer:
            if let playerInputState = currentState as? PlayerInputState {
                currentState = ComputerState(player: playerInputState.player.next,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
                gameboardView.onSelectPosition!(GameboardPosition(column: 0, row: 0))
            } else if let playerInputState = currentState as? ComputerState {
                currentState = PlayerInputState(player: playerInputState.player.next,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
            }
        case .severalMoves:
            if let playerInputState = currentState as? PlayerInput5x5State {
                currentState = PlayerInput5x5State(player: playerInputState.player.next,
                                                   gameViewController: self,
                                                   gameboard: gameboard,
                                                   gameboardView: gameboardView)
            }
        case .normal:
            if let playerInputState = currentState as? PlayerInputState {
                currentState = PlayerInputState(player: playerInputState.player.next,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
            }
        }
        
    }
    
    func restart() {
        gameboardView.clear()
        gameboard.clear()
        self.setFirstState()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        restart()
    }
}

