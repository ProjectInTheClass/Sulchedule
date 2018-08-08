import Foundation
import AudioToolbox.AudioServices

// 'Peek' feedback (weak boom)
let peek = SystemSoundID(1519)
// 'Pop' feedback (strong boom)
let pop = SystemSoundID(1520)
// 'Cancelled' feedback (three sequential weak booms)
let cancelled = SystemSoundID(1521)
// 'Try Again' feedback (week boom then strong boom)
let tryAgain = SystemSoundID(1102)
// 'Failed' feedback (three sequential strong booms)
let failed = SystemSoundID(1107)

var isBrightTheme = false
var isVibrationOn = true

let colorYellow = hexStringToUIColor(hex:"FFC400")
let colorGreen = hexStringToUIColor(hex:"72FF7D")
let colorRed = hexStringToUIColor(hex:"FF6060")
let colorGray = hexStringToUIColor(hex:"A4A4A4")
var colorPoint = hexStringToUIColor(hex:"FFDC67")
var colorLightBackground = hexStringToUIColor(hex:"252B53")
var colorDeepBackground = hexStringToUIColor(hex:"0B102F")

protocol Control2VCDelegate {
    func sendData(data:Int)
}
protocol VC2ControlDelegate {
    func sendData(data:Int)
}

//func reloadTabBarColor(){
//    self.tabBarController?.tabBar.backgroundColor = colorLightBackground
//    self.tabBarController?.tabBar.tintColor = colorPoint
//}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
