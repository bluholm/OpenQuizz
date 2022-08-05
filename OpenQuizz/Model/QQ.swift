 //
//  QQ.swift
//  OpenQuizz
//
//  Created by Marc-Antoine BAR on 2022-08-03.
//

import UIKit

class QQ: UIView {
    

    @IBOutlet private var lab: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    var title: String = "" {
        didSet {
            lab.text = title
        }
    }
    
    enum Style {
        case correct, incorrect, standart
    }
    
    var style :  Style = .standart {
        didSet{
            setStyle(style)
        }
    }
    
    private func setStyle (_ style: Style){
        switch style {
        case  .correct :
            backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
            
        case .incorrect :
            backgroundColor =  #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            icon.image = UIImage(named: "Icon Error")
            icon.isHidden = false
        case .standart :
            backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            icon.isHidden = true
        }
    }
    
     
}
