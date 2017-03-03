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
      Alamofire.request("http://machina123.ddns.net:8080/dstepinski/hangman.php", method: .get, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseString { (response) in
        self.riddleWord = response.result.value!.uppercased()
        self.prepareGame()
      }
    }
    
    func prepareGame() -> Void {
        discoverdWord = [String](repeating: "_", count: riddleWord.characters.count);
        refreshGameField()
    }
    
    func refreshGameField() -> Void {
        lblGameField.text! = ""
        lblUsedLetters.text! = "Wykorzystane: "
        
        for i in 0 ..< discoverdWord!.count {
            lblGameField.text! += discoverdWord![i] + " "
        }
        
        for j in 0 ..< usedLetters.count {
            lblUsedLetters.text! += usedLetters[j] + ", "
        }
    }
    
    @IBAction func gameProgress(_ sender: AnyObject) {
        checkLetter(inputLetter.text!.uppercased())
    }
    
    func advanceLoss() -> Void {
      currentCoverTag += 1
        let imageCover : UIImageView? = self.view!.viewWithTag(currentCoverTag) as? UIImageView
        imageCover!.isHidden = true;
        if(currentCoverTag > 1005) {
            let alertController = UIAlertController(title: "Koniec gry!", message: "Koniec gry, zostałeś powieszony na szubienicy, koksie! Sorry M8", preferredStyle: .alert)
            let alertActon = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: alertHandler)
            
            alertController.addAction(alertActon)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func checkLetter(_ letter : String) -> Void {
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
        
        for i in 0 ..< riddleWord.characters.count {
            let currentIndex = riddleWord.characters.index(riddleWord.startIndex, offsetBy: i)
            if(String(riddleWord.uppercased()[currentIndex]) == checkedLetter) {
                discoveredLetters += 1
                discoveries += 1
                discoverdWord![i] = checkedLetter
            }

        }
        if(discoveries == 0) {
            advanceLoss()
        }
        
        refreshGameField()
        
        if(discoveredLetters == riddleWord.characters.count) {
            let alertController = UIAlertController(title: "Wygrana!", message: "Koniec gry, wszystie litery odkryte", preferredStyle: .alert)
            let alertActon = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: alertHandler)
            
            alertController.addAction(alertActon)
            
            self.present(alertController, animated: true, completion:nil)
        }
        
        
    }
    
    func alertHandler(_ alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }
}
