//
//  ViewController.swift
//  FinalAssessmentCollectionView
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 VictorBasic. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI



class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

//    func isDistanceAvailable() -> Bool{
//    return true
//    }
//    func startUpdates(from start: Date, withHandler handler: @escaping CMPedometerHandler){
//    
//    }

    
    var counter = 0
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()

    
    var labelInTheCellArray = ["1","2","3","4","5","6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        var cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = TimeZone.self
    //    cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)!
        
//        #if arch(i386) || arch(x86_64) && os(iOS)
            
            // Simulator
            
//        #else
            // Run only in Physical Device, iOS
            
            if(CMPedometer.isStepCountingAvailable()){

                
                self.pedoMeter.startUpdates(from: midnightOfToday) { (data: CMPedometerData?, error) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(error == nil){
                            print("\(data!.numberOfSteps)")
                            //self.step.text = "\(data!.numberOfSteps)"
                        }
                    })
                }
            }else{
            print(CMPedometer.isStepCountingAvailable())
            
            }
//        #endif
    

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("有碰到嗎")
        if counter % 2 == 0{
            view.backgroundColor = UIColor.red
            counter += 1
        }else {
            view.backgroundColor = UIColor.blue
            counter += 1
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelInTheCellArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        cell.labelInTheCell.text = labelInTheCellArray[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            
            let myAlert = UIAlertController(title: "還少了點什麼喔", message: "按下ＯＫ回到主頁面", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel){
                (action:UIAlertAction) in
            }
            myAlert.addAction(okAction)
            present(myAlert, animated: true, completion: nil)
            
        }else if indexPath.item == 1{
            if counter % 2 == 0{
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor.red
                counter += 1
            }else {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor.blue
                counter += 1
            }
            
            print("有進來這個區域嗎")
            
            
        }else if indexPath.item == 2{
            let cell =  collectionView.cellForItem(at: [0,2]) as? MainCollectionViewCell
            
            if (CMPedometer.isStepCountingAvailable()) != true{
                
                cell?.labelInTheCell.text = "此設備不支援計步功能" //labelInTheCellArray[indexPath.row]
                
            }
            
            
            
        }else if indexPath.item == 3{
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            
            //     UIApplication.shared.openURL(URL(string:"prefs:root=General&path=About")!)
            
            
            
        }else if indexPath.item == 4{
            //          let location = touch.locationInNode(self)
            //          let node = self.nodeAtPoint(location)
            
            var i = true
            //    if node.name == "openMaps"
            if i == true{
                let customURL = "comgooglemaps://?saddr=Taipei+Main+Station&daddr=Alpha+Camp&zoom=10"
                
                if UIApplication.shared.canOpenURL(NSURL(string: customURL) as! URL) {
                    UIApplication.shared.openURL(NSURL(string: customURL) as! URL)
                }
                else {
                    var alert = UIAlertController(title: "Error", message: "Google maps not installed", preferredStyle: UIAlertControllerStyle.alert)
                    var ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated:true, completion: nil)
                }
            }
            
            UIApplication.shared.canOpenURL(
                NSURL(string: "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")! as URL)
            
        }else if indexPath.item == 5{
            let mailController = MFMailComposeViewController()
            if MFMailComposeViewController.canSendMail(){ //這個if是檢查是否有發mail
                mailController.setSubject("測試信件")
                mailController.setToRecipients(["issuehung@gmail.com"])
                mailController.setMessageBody("Test Message body", isHTML: false)
                mailController.mailComposeDelegate = self // 指派delegate給自己
                
                
                self.present(mailController, animated: true, completion: nil)
                
                
            }
            
            
            
        }
    }
    
    
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width)/2
        print(collectionView.frame.width)
        
        return CGSize(width:width, height: width)
    }
    
    
    
    
}

extension ViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
