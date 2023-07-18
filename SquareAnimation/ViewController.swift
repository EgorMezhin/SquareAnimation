//
//  ViewController.swift
//  SquareAnimation
//
//  Created by Egor Mezhin on 18.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private struct Constants {
        static let squareSize: CGFloat = 100
        static let cornerRadius: CGFloat = 10
        static let dumping =  1.5
    }

    private lazy var square: UIView = {
        var view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: self.view.center.x - Constants.squareSize / 2,
                            y: self.view.center.y - Constants.squareSize / 2,
                            width: Constants.squareSize,
                            height: Constants.squareSize)
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private lazy var dynamicAnimator = UIDynamicAnimator(referenceView: view)
    private lazy var collisionBehavior = UICollisionBehavior()

    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addCollisionBehavior()
        setupGestureRecognizer()
    }
}

extension ViewController {
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(square)
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(didTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func addCollisionBehavior() {
        collisionBehavior = UICollisionBehavior(items: [square])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
    }

    @objc
    private func didTap(_ touch: UITapGestureRecognizer) {
        if let snapBehavior {
            dynamicAnimator.removeBehavior(snapBehavior)
        }
        let location = touch.location(in: view)
        snapBehavior = UISnapBehavior(item: square, snapTo: location)
        snapBehavior.damping = Constants.dumping
        dynamicAnimator.addBehavior(snapBehavior)
    }
}
