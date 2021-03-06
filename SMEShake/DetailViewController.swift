//
//  DetailViewController.swift
//  SMEShake
//
//  Created by Hakan Yildizay [Mobil Yazilim  Servisi] on 09/06/2017.
//  Copyright © 2017 ING BANK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var lblBubble: UILabel!
    @IBOutlet var imgEmoji: UIImageView!
    @IBOutlet var slidingTexts: SlidingText!
    @IBOutlet var bubbleContainer: UIView!
    @IBOutlet var portraits: [UIImageView]!
    
    var tapGesture : UITapGestureRecognizer? = nil
    var currentMode : Int = 1 //Show must go on Mode on
    var speeches = Dictionary<String,String>()
    var emojis = Dictionary<String,String>()
    override var canBecomeFirstResponder: Bool { return true}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let theSpeeches =  self.readJson(fileName: "speech") else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let theEmojis = self.readJson(fileName: "emoji") else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.speeches = theSpeeches
        self.emojis =  theEmojis
        let numberOfItems =  min(theSpeeches.count, theEmojis.count)
        self.shake(numberOfItems: numberOfItems)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let text = self.slidingTexts
        text?.pause()
        self.slidingTexts.alpha = 0.0
    }
    
    /*
     0 - Editing
     1 - Show Must go on
     */
    func changeMode(to:Int){
        
        self.currentMode = to
        
        if to == 0 {
            
            if self.tapGesture == nil{
                let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(DetailViewController.tapImage(_:)))
                self.tapGesture = tapGestureRecognizer
                self.view.addGestureRecognizer(tapGestureRecognizer)
            }
            
            UIView.animate(withDuration: 0.7, animations: {
                self.imgEmoji.alpha = 0.0
                self.bubbleContainer.alpha = 0.0
                self.slidingTexts.alpha = 1.0
                self.slidingTexts.start()
                
                for portrait in self.portraits{
                    portrait.alpha = 1.0
                }
            })
            
            
        }else{
            
            UIView.animate(withDuration: 0.7, animations: {
                self.imgEmoji.alpha = 1.0
                self.bubbleContainer.alpha = 1.0
                self.slidingTexts.alpha = 0.0
                self.slidingTexts.pause()
                
                for portrait in self.portraits{
                    portrait.alpha = 0.0
                }
            })
            
        }
        
    }

    func tapImage(_ recognizer: UITapGestureRecognizer){
     
        if self.currentMode == 0{
            self.changeMode(to: 1 - self.currentMode)
        }
        
    }
    
    @IBAction func infoTapped(_ sender: UIButton) {
        let nextMode = 1 - self.currentMode
        self.changeMode(to: nextMode)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        guard let motionEvent = event else { return }
        
        if motionEvent.type == .motion {
            let numberOfItems =  min(self.speeches.count, self.emojis.count)
            self.shake(numberOfItems: numberOfItems)
        }
        
    }
    
    func shake(numberOfItems: Int){
        
        if self.currentMode == 0 { return }
        
        let randomNumber = String(Int(arc4random_uniform(UInt32(numberOfItems))) + 1)
        let speech = self.speeches[randomNumber] ?? ""
        let emojiName  = self.emojis[randomNumber] ?? "0"
        self.imgEmoji.image = UIImage(named: emojiName)
        self.lblBubble.text = speech
        
        self.imgEmoji.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.imgEmoji.alpha = 0.5
        
        
        UIView.animate(withDuration: 0.7, animations: {
            self.imgEmoji.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.imgEmoji.alpha = 1.0
        }) { (isFinished : Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.imgEmoji.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func readJson(fileName:String) -> Dictionary<String,String>? {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: String] {
                    // json is a dictionary
                    return object
                } else if json is [Any] {
                    // json is an array
                    return nil
                } else {
                    print("JSON is invalid")
                    return nil
                }
            } else {
                print("no file")
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
