//
//  ViewController.swift
//  Barca a Vela
//
//  Created by Michele Bigi on 10/05/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TimoneSlider: UISlider!
    @IBOutlet weak var RandaSlider: UISlider!
    @IBOutlet weak var FioccoSlider: UISlider!
    
    @IBOutlet weak var TimoneLabel: UILabel!
    @IBOutlet weak var RandaLabel: UILabel!
    @IBOutlet weak var FioccoLabel: UILabel!
    
    
    @IBOutlet weak var DYN_AX: UILabel!
    @IBOutlet weak var DYN_AY: UILabel!
    @IBOutlet weak var DYN_AZ: UILabel!
    
    @IBOutlet weak var DYN_MX: UILabel!
    @IBOutlet weak var DYN_MY: UILabel!
    @IBOutlet weak var DYN_MZ: UILabel!
    
    @IBOutlet weak var DYN_GX: UILabel!
    @IBOutlet weak var DYN_GY: UILabel!
    @IBOutlet weak var DYN_GZ: UILabel!
    
    @IBOutlet weak var Aggiorna: UIButton!
    
    func infoRequest() -> Data? {
        guard let url = URL(string: "http://arduinobarca.local/arduino/info/22") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("[ERROR] There is an unspecified error with the connection")
            return nil
        }
        
        print("[CONNECTION] OK, data correctly downloaded")
        return data
    }
    
    func json_parseData(data: Data) -> NSDictionary? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            print("[JSON] OK!")
            //print(json)
            return (json as? NSDictionary)
        } catch _ {
            print("[ERROR] An error has happened with parsing of json data")
            return nil
        }
    }
    
    func writeLabel ( label :UILabel ,  numb :NSNumber ){
        label.text = numb.stringValue
    }
    
    func aggiornaDinamica( ) {
        let data = infoRequest()
        let json = json_parseData(data: data!)
        
        let accel = json?[ "accel" ] as! NSDictionary
        let magn = json?[ "magn" ] as! NSDictionary
        let gyro = json?[ "gyro" ] as! NSDictionary
    
       // DYN_AX.text = ax.stringValue
        writeLabel(label: DYN_AX , numb: accel["x"] as! NSNumber )
        writeLabel(label: DYN_AY , numb: accel["y"] as! NSNumber )
        writeLabel(label: DYN_AZ , numb: accel["z"] as! NSNumber )
        
        writeLabel(label: DYN_MX , numb: magn["x"] as! NSNumber )
        writeLabel(label: DYN_MY , numb: magn["y"] as! NSNumber )
        writeLabel(label: DYN_MZ , numb: magn["z"] as! NSNumber )
        
        writeLabel(label: DYN_GX , numb: gyro["x"] as! NSNumber )
        writeLabel(label: DYN_GY , numb: gyro["y"] as! NSNumber )
        writeLabel(label: DYN_GZ , numb: gyro["z"] as! NSNumber )


    }
    
    @IBAction func AggiornaButton(_ sender: Any) {
                //print(json?[ "gyro"] )
        //print(json?[ "magn"] )
        aggiornaDinamica()
      
    }
    
    func sendCommand(  pos : Int32 , servo : String) {
        var request = URLRequest(url: URL(string: "http://arduinobarca.local/arduino/\(servo)/\(pos)" )!)
        request.httpMethod = "POST"
        let postString = "id=13&name=Jack"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func setTimoneDisplay() {
        var currentVal = Int32(TimoneSlider.value)
        TimoneLabel.text = "\(currentVal)"
        sendTimone(pos: currentVal+90)
    }
    
    func setRandaDisplay() {
        var currentVal = Int32(RandaSlider.value)
        RandaLabel.text = "\(currentVal)"
        sendRanda(pos: currentVal)
    }
    
    func setFioccoDisplay() {
        var currentVal = Int32(FioccoSlider.value)
        FioccoLabel.text = "\(currentVal)"
        sendFiocco(pos: currentVal)
    }
    
    @IBAction func TimoneUpOutsideAction(_ sender: Any) {
        setTimoneDisplay()
    }
    @IBAction func TimoneUpInsideAction(_ sender: Any) {
       setTimoneDisplay()
    }
    
    func sendTimone(  pos : Int32 ) {
        sendCommand( pos: pos , servo:  "timone" )
    }
    
    func sendRanda(  pos : Int32 ) {
        sendCommand( pos: pos , servo:  "randa" )
    }
    func sendFiocco(  pos : Int32 ) {
        sendCommand( pos: pos , servo:  "fiocco" )
    }
    
    @IBAction func TimoneSliderValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func TimoneSliderAct(_ sender: Any) {
        

    }
  
    @IBAction func RandaUpOutside(_ sender: Any) {
        setRandaDisplay()
    }
    
   
    @IBAction func RandaUpInside(_ sender: Any) {
        setRandaDisplay()
    }
    
    @IBAction func FioccoUpOutside(_ sender: Any) {
        setFioccoDisplay()
        
    }
    
    @IBAction func FioccoUpInside(_ sender: Any) {
        setFioccoDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

