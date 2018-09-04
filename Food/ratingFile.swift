//
//  ratingFile.swift
//  Food
//
//  Created by Gouthami Reddy on 8/16/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit

@IBDesignable class ratingFile: UIStackView {
    
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder:coder)
        setUpButtons()
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setUpButtons()
        }
    }
    
    @IBInspectable var startCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    private func setUpButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filled Star", in: bundle,compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "empty star", in: bundle, compatibleWith: self.traitCollection)
        let heighlightedStar = UIImage(named: "highlighed star", in: bundle, compatibleWith: self.traitCollection)
        ratingButtons.removeAll()
        for index in 0..<startCount{
        let button = UIButton()
      
       button.setImage(emptyStar, for: .normal)
       button.setImage(filledStar, for: .selected)
       button.setImage(heighlightedStar, for: .highlighted)
        button.setImage(heighlightedStar, for: [.highlighted,.selected])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        button.accessibilityLabel = "Set \(index + 1) star rating"
        button.addTarget(self, action: #selector(ratingFile.ratingButton(button: )),for: .touchUpInside)
            addArrangedSubview(button)
          ratingButtons.append(button)
    }
        updateButtonSelectionState()
    }
    @objc func ratingButton(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("the button,\(button),is not in the ratingButtons array:\(ratingButtons)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
        rating = selectedRating
        }
    }
    private func updateButtonSelectionState() {
        for(index,button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero" }
            else {
                hintString = nil
                
            }
            let valueString: String
            switch(rating) {
            case 0: valueString = "no rating set."
            case 1: valueString = "1 star selected"
            default: valueString = "\(rating) stars set"
            }
            button.accessibilityHint = hintString
            button.accessibilityLabel = valueString
        }
    }
}
