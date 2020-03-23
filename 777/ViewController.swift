//
//  ViewController.swift
//  777
//
//  Created by sinyilin on 2020/3/20.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var bossImageView: UIImageView!
    @IBOutlet weak var mybloodView: UIView!
    @IBOutlet weak var bloodView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var myImageView: UIImageView!
    var myPlayer:AVAudioPlayer!
    var imagArray = [UIImage(named: "Aquarius"),UIImage(named: "Pisces"),UIImage(named: "Aries"),UIImage(named: "Taurus"),UIImage(named: "Gemini"),UIImage(named: "Cancer"),UIImage(named: "Leo"),UIImage(named: "Virgo"),UIImage(named: "Libra"),UIImage(named: "Scorpio"),UIImage(named: "Sagittarius"),UIImage(named: "Capricorn")]
    var order1Array = [Int]()
    var order2Array = [Int]()
    var order3Array = [Int]()
    var timer1:Timer!
    var timer2:Timer!
    var timer3:Timer!
    var currentRow1 = 0
    var currentRow2 = 0
    var currentRow3 = 0
    var pickerRow1 = 0
    var pickerRow2 = 0
    var pickerRow3 = 0
    var bossRandom = 0
    var myRandom = 0
    var originMyImageViewY = 0
    var originBossImageViewY = 0
    @IBOutlet weak var bossAttackImageView: UIImageView!
    @IBOutlet weak var myAttackImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "backgroud", ofType: "mp3")
        do
        {
            myPlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: filePath!) as URL)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
            myPlayer.numberOfLoops = -1
            myPlayer.play()
        }
        catch
        {
            print("error:\(error.localizedDescription)")
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        for _ in 0...11 {
            order1Array.append((Int)(arc4random() % 12))
            order2Array.append((Int)(arc4random() % 12))
            order3Array.append((Int)(arc4random() % 12))
        }
        bossRandom = (Int)(arc4random() % 12)
        myRandom = (Int)(arc4random() % 12)
        while bossRandom == myRandom {
            bossRandom = (Int)(arc4random() % 12)
            myRandom = (Int)(arc4random() % 12)
        }
        print("bossRandom:\(bossRandom)")
        print("myRandom:\(myRandom)")
        bossImageView.image = imagArray[bossRandom]
        bossAttackImageView.image = UIImage(named: "bomb")
        bossAttackImageView.alpha = 0
        myImageView.image = imagArray[myRandom]
        myAttackImageView.image = UIImage(named: "missile")
        myAttackImageView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originMyImageViewY = Int(self.myAttackImageView.frame.origin.y)
        originBossImageViewY = Int(self.bossAttackImageView.frame.origin.y)
        print("originMyImageViewY:\(originMyImageViewY),originBossImageViewY:\(originBossImageViewY)")
    }
    @objc func timerAction()
    {
        currentRow1 += 1
        pickerRow1 += Int(arc4random())%12
        self.pickerView.selectRow(pickerRow1, inComponent: 0, animated: true)
        if currentRow1 == 10
        {
            self.timer1.invalidate()
            self.timer1 = nil
        }
        
    }
    @objc func timerAction2(){
        currentRow2 += 1
        pickerRow2 += Int(arc4random())%12
        self.pickerView.selectRow(pickerRow2, inComponent: 1, animated: true)
        if currentRow2 == 10
        {
            self.timer2.invalidate()
            self.timer2 = nil
        }
    }
    @objc func timerAction3(){
        currentRow3 += 1
        pickerRow3 += Int(arc4random())%12
        self.pickerView.selectRow(pickerRow3, inComponent: 2, animated: true)
        if currentRow3 == 10
        {
            self.timer3.invalidate()
            self.timer3 = nil
            var bossReduce = 0
            var myReduce = 0
            
            if order1Array[pickerView.selectedRow(inComponent: 0) % 12] == order2Array[pickerView.selectedRow(inComponent: 1) % 12] && order1Array[pickerView.selectedRow(inComponent: 0) % 12] == order3Array[pickerView.selectedRow(inComponent: 2) % 12]
            {
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                    self.bloodView.frame.origin.x -= self.view.frame.width
                }) { (b) in
                    if b
                    {
                        let alertc = UIAlertController(title: "你贏了", message: "一擊斃命直接獲勝", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                        alertc.addAction(alertAction)
                        self.present(alertc, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                if order1Array[pickerView.selectedRow(inComponent: 0) % 12] == bossRandom
                {
                    bossReduce += 1
                }
                if order2Array[pickerView.selectedRow(inComponent: 1) % 12] == bossRandom
                {
                    bossReduce += 1
                }
                if order3Array[pickerView.selectedRow(inComponent: 2) % 12] == bossRandom
                {
                    bossReduce += 1
                }
                if order1Array[pickerView.selectedRow(inComponent: 0) % 12] == myRandom
                {
                    myReduce += 1
                }
                if order2Array[pickerView.selectedRow(inComponent: 1) % 12] == myRandom
                {
                    myReduce += 1
                }
                if order3Array[pickerView.selectedRow(inComponent: 2) % 12] == myRandom
                {
                    myReduce += 1
                }
                if myReduce > bossReduce
                {
                    self.myAttackImageView.alpha = 1
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.myAttackImageView.frame.origin.y = self.bossImageView.frame.origin.y + self.bossImageView.frame.size.height
                    }) { (bool) in
                        if bool
                        {
                            self.myAttackImageView.alpha = 0
                            self.myAttackImageView.frame.origin.y = CGFloat(self.originMyImageViewY)
                            UIView.animate(withDuration: 0.5, delay: 0, options: .autoreverse, animations: {
                                self.bossImageView.alpha = 0
                            }){
                                (b) in
                                if b
                                {
                                    self.bossImageView.alpha = 1
                                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                                        self.bloodView.frame.origin.x -= self.view.frame.width * (CGFloat(myReduce - bossReduce)*0.1)
                                    }){
                                        (_) in
                                    }
                                }
                            }
                        }
                    }
                }
                if (bossReduce > myReduce)
                {
                    self.bossAttackImageView.alpha = 1
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.bossAttackImageView.frame.origin.y = self.myImageView.frame.origin.y - self.bossAttackImageView.frame.size.height
                    }) { (bool) in
                        if bool
                        {
                            self.bossAttackImageView.alpha = 0
                            self.bossAttackImageView.frame.origin.y = CGFloat(self.originBossImageViewY)
                            UIView.animate(withDuration: 0.5, delay: 0, options: .autoreverse, animations: {
                                self.myImageView.alpha = 0
                            }){
                                (b) in
                                if b
                                {
                                    self.myImageView.alpha = 1
                                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                                        self.mybloodView.frame.origin.x += self.mybloodView.frame.size.width * (CGFloat(bossReduce - myReduce)*0.1)
                                    }){
                                        (_) in
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func click(_ sender: UIButton) {
       
        currentRow1 = 0
        currentRow2 = 0
        currentRow3 = 0
        pickerRow1 = 0
        pickerRow2 = 0
        pickerRow3 = 0
        self.timer1 = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//        sleep(1)
        self.timer2 = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerAction2), userInfo: nil, repeats: true)
//        sleep(2)
        self.timer3 = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerAction3), userInfo: nil, repeats: true)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let v = UIImageView()
        switch component {
        case 0:
            v.image = imagArray[order1Array[row % 12]]
//            v.backgroundColor = UIColor.red
            break
        case 1:
            v.image = imagArray[order2Array[row % 12]]
//            v.backgroundColor = UIColor.blue
            break
        case 2:
            v.image = imagArray[order3Array[row % 12]]
//            v.backgroundColor = UIColor.black
            break
        default:
            break
        }
        return v
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10000
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    
}

