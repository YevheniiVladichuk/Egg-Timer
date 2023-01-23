//
//  ViewController.swift
//  eggTimer
//
//  Created by Yevhenii Vladichuk on 13/01/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let verticalStack = UIStackView()
    let topView = UIView()
    let titleLabel = UILabel()
    let middleView = UIView()
    let eggsStack = UIStackView()
    let bottomView = UIView()
    
    let softEggButton = UIButton()
    let mediumEggButton = UIButton()
    let hardEggButton = UIButton()
    
    let progressBar = UIProgressView()
    let stopButton = UIButton()
    
    let cookingTime = ["Soft": 3, "Medium": 4, "Hard": 6]
    //soft 360, medium 480, hard 600
    lazy var workItem = DispatchWorkItem() {
        self.resetView()
    }
    
    var player: AVAudioPlayer!
    var timer = Timer()
    var totalTime = 0
    var secondPasssed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVerticalStack()
        configTitleLabel()
        configMiddleView()
        configTimerView()
        configProgressBar()
        
        configButton(button: softEggButton, title: "Soft", image: "soft_egg")
        configButton(button: mediumEggButton, title: "Medium", image: "medium_egg")
        configButton(button: hardEggButton, title: "Hard", image: "hard_egg")
    }
    
    func configVerticalStack(){
        view.addSubview(verticalStack)
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.backgroundColor = UIColor(red: 59/255.0, green: 127/255.0, blue: 240/255.0, alpha: 1)
        
        //constraint
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    //top view
    func configTitleLabel() {
        verticalStack.addArrangedSubview(topView)
        topView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -15).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor).isActive = true
        
        titleLabel.text = "Which eggs do you prefer ?"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Helvetica Bold", size: 25)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.backgroundColor = UIColor(red: 253/255.0, green: 209/255.0, blue: 1/255.0, alpha: 1)
        titleLabel.layer.cornerRadius = 15
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.borderWidth = 1
    }
    
    //middle view
    func configMiddleView() {
        verticalStack.addArrangedSubview(middleView)
        
        middleView.addSubview(eggsStack)
        
        eggsStack.axis = .horizontal
        eggsStack.spacing = 10
        eggsStack.distribution = .fillEqually
        eggsStack.translatesAutoresizingMaskIntoConstraints = false
        eggsStack.topAnchor.constraint(equalTo: self.middleView.topAnchor, constant: 45).isActive = true
        eggsStack.bottomAnchor.constraint(equalTo: self.middleView.bottomAnchor, constant: -45).isActive = true
        eggsStack.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor, constant: 10).isActive = true
        eggsStack.trailingAnchor.constraint(equalTo: self.middleView.trailingAnchor, constant: -10).isActive = true
    }
    
    //bottom view
    func configTimerView(){
        verticalStack.addArrangedSubview(bottomView)
    }
    
    //buttons
    func configButton(button: UIButton, title: String, image: String){
        eggsStack.addArrangedSubview(button)
        
        let image = UIImage(named: image) as UIImage?
        button.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 18)
        button.contentMode = .scaleAspectFill
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(hardnessButtonChooseTapped), for: .touchUpInside)
    }
    
    func configProgressBar() {
        bottomView.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.heightAnchor.constraint(equalToConstant: 8).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 30).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor, constant: -30).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: self.bottomView.centerYAnchor).isActive = true
        progressBar.trackTintColor = .gray
        progressBar.alpha = 0.5
        progressBar.tintColor = UIColor(red: 253/255.0, green: 209/255.0, blue: 1/255.0, alpha: 1)
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.borderWidth = 1
    }
    
    func configStopButton(){
        bottomView.addSubview(stopButton)
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        stopButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 20).isActive = true
        
        stopButton.setTitle("Stop", for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        stopButton.backgroundColor = UIColor(red: 253/255.0, green: 209/255.0, blue: 1/255.0, alpha: 1)
        stopButton.setTitleColor(.black, for: .normal)
        stopButton.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 18)
        stopButton.layer.cornerRadius = 15
        stopButton.layer.borderWidth = 1
        stopButton.alpha = 0
        stopButton.isEnabled = false
    }
    
    @objc func stopButtonTapped(){
        player.stop()
        resetView()
        workItem.cancel()
    }
    
    @objc func hardnessButtonChooseTapped(sender: UIButton!){
        configStopButton()
        timer.invalidate()
        totalTime = cookingTime[sender.currentTitle!]!
        progressBar.alpha = 1
        progressBar.progress = 0.0
        titleLabel.text = sender.currentTitle!
        secondPasssed = 0
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if secondPasssed < totalTime {
            secondPasssed += 1
            let percentageProgress = Float(secondPasssed) / Float(totalTime)
            progressBar.progress = percentageProgress
        } else {
            //after time has gone
            timer.invalidate()
            
            //if user didn't tap the stop button, reset the view after sound will end
            if workItem.isCancelled == true {
                workItem = DispatchWorkItem() {
                    self.resetView()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 28.0, execute: workItem)
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 29.0, execute: workItem)
            }
            
            titleLabel.backgroundColor = UIColor(red: 0/255.0, green: 201/255.0, blue: 19/255.0, alpha: 1)
            titleLabel.text = "DONE !"
            let url = Bundle.main.url(forResource: "sound", withExtension: "mp3")
            player  = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            stopButton.isEnabled = true
            stopButton.alpha = 1
        }
    }
    
    func resetView(){
        stopButton.isEnabled = false
        stopButton.alpha = 0
        titleLabel.text = "Which eggs do you prefer ?"
        titleLabel.backgroundColor = UIColor(red: 253/255.0, green: 209/255.0, blue: 1/255.0, alpha: 1)
        progressBar.alpha = 0.5
        progressBar.progress = 0.0
    }
}
