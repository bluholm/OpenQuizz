//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Marc-Antoine BAR on 2022-08-01.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer){
        if game.state == .ongoing {
            switch sender.state{
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
        
        
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth/2)
        let rotatingAngle = (CGFloat.pi/6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotatingAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)

        questionView.transform = transform
        
        if (translation.x > 0){
            questionView.style = .correct
        }else {
            questionView.style = .incorrect
        }
        
    }
    private func answerQuestion(){
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        default:
            break
        }
        questionLabelTotal.text = "\(game.score) / 10"
        
        questionView.transform = .identity
        questionView.style = .standart
        questionView.title = game.currentQuestion.title
        
        switch game.state {
            case .ongoing:
                questionView.title = game.currentQuestion.title
            case .over:
            questionView.title = "Game Over"
        }
        
        
        
        let screenWidth = UIScreen.main.bounds.width
                var translationTransform: CGAffineTransform
                if questionView.style == .correct {
                    translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
                } else {
                    translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
                }

                UIView.animate(withDuration: 0.3, animations: {
                    self.questionView.transform = translationTransform
                }, completion: { (success) in
                    if success {
                        self.showQuestionView()
                    }
                })
        
        
        
        
    }
    
    
    private func showQuestionView() {
            questionView.transform = .identity
            questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            questionView.style = .standart

            switch game.state {
            case .ongoing:
                questionView.title = game.currentQuestion.title
            case .over:
                questionView.title = "Game Over"
            }

            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.questionView.transform = .identity
            }, completion:nil)
        }
    
    
    
    @objc func questionLoaded () {
        indicatorActivity.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        
        
    }
    
    var game = Game()

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    @IBOutlet weak var questionLabelTotal: UILabel!
    @IBOutlet weak var questionView: QQ!
    
    
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    func startNewGame(){
        newGameButton.isHidden = true
        indicatorActivity .isHidden = false
        questionView.style = .standart
        questionView.title = "Loading..."
        
        questionLabelTotal.text = "0/10"
        
        game.refresh()
    }
}

