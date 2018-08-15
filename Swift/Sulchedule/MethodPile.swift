import Foundation
import AudioToolbox.AudioServices

// 'Peek' feedback (weak boom)
let vibPeek = SystemSoundID(1519)
// 'Pop' feedback (strong boom)
let vibPop = SystemSoundID(1520)
// 'Cancelled' feedback (three sequential weak booms)
let vibCancelled = SystemSoundID(1521)
// 'Try Again' feedback (week boom then strong boom)
let vibTryAgain = SystemSoundID(1102)
// 'Failed' feedback (three sequential strong booms)
let vibFailed = SystemSoundID(1107)

let colorYellow = hexStringToUIColor(hex:"FFC400")
let colorGreen = hexStringToUIColor(hex:"4AD863")
let colorRed = hexStringToUIColor(hex:"FF6060")
var colorGray = hexStringToUIColor(hex:"A4A4A4")
var colorPoint = hexStringToUIColor(hex:"FFDC67")
var colorLightBackground = hexStringToUIColor(hex:"252B53")
var colorDeepBackground = hexStringToUIColor(hex:"0B102F")
var colorText = hexStringToUIColor(hex:"FFFFFF")

let deviceCategory: Int = UIDevice.current.value(forKey: "_feedbackSupportLevel")! as! Int

protocol Control2VCDelegate {
    func sendData(data:Int)
}
protocol VC2ControlDelegate {
    func sendData(data:Int)
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
}


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

func dateToDayConverter(date: Date) -> Day{
    let initFormatter = DateFormatter()
    initFormatter.dateFormat = "d"
    let day = initFormatter.string(from: date)
    initFormatter.dateFormat = "M"
    let month = initFormatter.string(from: date)
    initFormatter.dateFormat = "yyyy"
    let year = initFormatter.string(from: date)
    
    return Day(year: NumberFormatter().number(from: year)!.intValue, month: NumberFormatter().number(from: month)!.intValue, day: NumberFormatter().number(from: day)!.intValue)
}

func dateToMonthConverter(date: Date) -> Day{
    let initFormatter = DateFormatter()
    initFormatter.dateFormat = "M"
    let month = initFormatter.string(from: date)
    initFormatter.dateFormat = "yyyy"
    let year = initFormatter.string(from: date)
    
    return Day(year: NumberFormatter().number(from: year)!.intValue, month: NumberFormatter().number(from: month)!.intValue, day:nil)
}

var isLastMonth = 0
var monthmonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)

func changeIcon(to iconName: String) {
    guard UIApplication.shared.supportsAlternateIcons else {
        return
    }
    UIApplication.shared.setAlternateIconName(iconName, completionHandler: {(error) in
        if let error = error {
            print("App icon failed to change due to \(error.localizedDescription)")
        }
        else {
            print("App icon changed successfully")
        }
    })
}



