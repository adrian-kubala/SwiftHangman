//
//  GameViewController.swift
//  hangman
//
//  Created by Dawid Stępiński on 23.10.2015.
//  Copyright © 2015 BlackDragon. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class GameViewController : UIViewController {
    
    var selectedGroup : String = "";
    var selectedCategory : String = "";
    var riddleWord : String = "";
    var currentCoverTag : Int = 1000;
    var discoverdWord : [String]?
    var discoveredLetters : Int = 0
    var usedLetters : [String] = []
    
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblGameField: UILabel!
    @IBOutlet weak var lblUsedLetters: UILabel!
    
    override func viewDidLoad() {
        print(selectedGroup, selectedCategory)
        getRiddleWord()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRiddleWord() -> Void {
        let parameters = [
            "group": self.selectedGroup,
            "category": self.selectedCategory
        ]
        
        Alamofire.request(.GET, "http://machina123.ddns.net:8080/dstepinski/hangman.php", parameters: parameters).responseString { response in
            self.riddleWord = response.result.value!.uppercaseString
            self.prepareGame()
        }
    }
    
    func prepareGame() -> Void {
        discoverdWord = [String](count: riddleWord.characters.count, repeatedValue: "_");
        refreshGameField()
    }
    
    func refreshGameField() -> Void {
        lblGameField.text! = ""
        lblUsedLetters.text! = "Wykorzystane: "
        
        for var i = 0; i < discoverdWord!.count; i++  {
            lblGameField.text! += discoverdWord![i] + " "
        }
        
        for var j = 0; j < usedLetters.count; j++ {
            lblUsedLetters.text! += usedLetters[j] + ", "
        }
    }
    
    @IBAction func gameProgress(sender: AnyObject) {
        checkLetter(inputLetter.text!.uppercaseString)
    }
    
    func advanceLoss() -> Void {
        let imageCover : UIImageView? = self.view!.viewWithTag(currentCoverTag++) as? UIImageView
        imageCover!.hidden = true;
        if(currentCoverTag > 1005) {
            let alertController = UIAlertController(title: "Koniec gry!", message: "Koniec gry, zostałeś powieszony na szubienicy, koksie! Sorry M8", preferredStyle: .Alert)
            let alertActon = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: alertHandler)
            
            alertController.addAction(alertActon)
            
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    func checkLetter(letter : String) -> Void {
        var checkedLetter : String;
        var discoveries : Int = 0;
        
        inputLetter.text = ""
        
        if(letter.characters.count > 1) {
            checkedLetter = String(letter[letter.startIndex])
        } else if(letter.characters.count < 1) {
            //advanceLoss()
            return;
        } else {
            checkedLetter = letter;
        }
        
        if(usedLetters.contains(checkedLetter)) {
            return;
        }
        
        usedLetters.append(checkedLetter);
        
        for var i = 0; i < riddleWord.characters.count; i++ {
            let currentIndex = riddleWord.startIndex.advancedBy(i)
            if(String(riddleWord.uppercaseString[currentIndex]) == checkedLetter) {
                discoveredLetters++
                discoveries++
                discoverdWord![i] = checkedLetter
            }

        }
        if(discoveries == 0) {
            advanceLoss()
        }
        
        refreshGameField()
        
        if(discoveredLetters == riddleWord.characters.count) {
            let alertController = UIAlertController(title: "Wygrana!", message: "Koniec gry, wszystie litery odkryte", preferredStyle: .Alert)
            let alertActon = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: alertHandler)
            
            alertController.addAction(alertActon)
            
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        
        
    }
    
    func alertHandler(alert: UIAlertAction!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
