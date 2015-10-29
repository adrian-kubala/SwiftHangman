//
//  ViewController.swift
//  hangman
//
//  Created by Dawid Stępiński on 02.10.2015.
//  Copyright © 2015 BlackDragon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var selectedGroup = 0;
    var selectedCategory : Int = 0;
    
    var group = ["Technika","Biologia","Rozrywka","Sport","Muzyka","Motoryzacja"]
    var categories = [
        ["IT","Web"],
        ["Anatomia", "Wensze"],
        ["Impreza","Aplikacje Klienckie"],
        ["Tenis", "Hokej"],
        ["Klasyczna","Rock"],
        ["Auta", "Motory"]
    ]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(component == 0){
            return group.count
        }else{
            return categories[pickerView.selectedRowInComponent(0)].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        print("l:", component, pickerView.selectedRowInComponent(0))
        if(component == 0){
            print("grp",group[row])
            return group[row]
        }else{
            print("kat",categories[pickerView.selectedRowInComponent(0)][row])
           return categories[pickerView.selectedRowInComponent(0)][row]
        }
    }
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if(component == 0){
            selectedGroup = row
            print(selectedGroup)
            
        } else if(component == 1) {
            selectedCategory = row
            print(selectedCategory)
        }
    //    pickerView.reloadAllComponents()
        print("lol")
        pickerView.reloadComponent(1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! GameViewController
        dest.selectedGroup = group[selectedGroup]
        dest.selectedCategory = categories[selectedGroup][selectedCategory]
    }
}

