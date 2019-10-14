import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var hybridBtn: UIBarButtonItem!
    @IBOutlet weak var standardBtn: UIBarButtonItem!
    @IBOutlet weak var satelliteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        var annotation = Array<MKAnnotation>()
        
        let datas = NSArray(contentsOfFile: Bundle.main.path(forResource: "data", ofType: "plist")!)
        
        if let dataList = datas {
            for data in dataList {
                let address = (data as AnyObject).value(forKey: "address") as! String
                let title = (data as AnyObject).value(forKey: "title") as! String
                
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
                    if error != nil {
                        return
                    }
                    
                    if let placemarkList = placemarks {
                        let latitude = placemarkList.first?.location?.coordinate.latitude
                        let longitude = placemarkList.first?.location?.coordinate.longitude
                        
                        let geoCoderR = CLGeocoder()
                        
                        geoCoderR.reverseGeocodeLocation(CLLocation(latitude: latitude!, longitude: longitude!), completionHandler: { (placemarksR: [CLPlacemark]?, errorR: Error?) in
                            if errorR != nil {
                                return
                            }
                            
                            if let placemarkListR = placemarksR {
                                let country = placemarkListR.first?.country ?? "Empty"
                                let administrativeArea = placemarkListR.first?.administrativeArea ?? "Empty"
                                let locality = placemarkListR.first?.locality ?? "Empty"
                                let name = placemarkListR.first?.name ?? "Empty"
                                
                                let subtitle = address + " (" + country + " " + administrativeArea + " " + locality + " " + name + ")"
                                
                                let viewPoint = ViewPoint(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), title: title, subtitle: subtitle)
                                
                                annotation.append(viewPoint)
                                
                                if (annotation.count == dataList.count) {
                                    self.mapView.showAnnotations(annotation, animated: true)
                                    
                                    self.mapView.mapType = MKMapType.hybrid
                                    self.setEnables(hybrid: false, standard: true, satellite: true)
                                }
                            }
                        })
                    } else {
                        return
                    }
                })
            }
        }
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
            
            var imageData = "DIT.jpg"
            var imageFrame = CGRect(x: 0, y: 0, width: 120, height: 30)
            annotationView?.pinTintColor = UIColor.red
            
            let title = annotation.title
            
            if title == "동의과학대학교" {
                imageData = "DIT.jpg"
                imageFrame = CGRect(x: 0, y: 0, width: 120, height: 30)
                annotationView?.pinTintColor = UIColor.red
            } else if title == "부산여자대학교" {
                imageData = "BWU.png"
                imageFrame = CGRect(x: 0, y: 0, width: 100, height: 30)
                annotationView?.pinTintColor = UIColor.green
            } else {
                imageData = "BGU.jpeg"
                imageFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
                annotationView?.pinTintColor = UIColor.purple
            }
            
            let img = UIImageView(image: UIImage(named: imageData))
                
            img.frame = imageFrame
            
            annotationView?.leftCalloutAccessoryView = img
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control.state.rawValue == 1) {
        
            let alert = UIAlertController(title: view.annotation?.title!, message: view.annotation?.subtitle!, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "확인", style: .destructive)
        
            alert.addAction(okAction)
            
            present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func changeHybrid(_ sender: Any) {
        mapView.mapType = MKMapType.hybrid
        setEnables(hybrid: false, standard: true, satellite: true)
    }
    
    @IBAction func changeStandard(_ sender: Any) {
        mapView.mapType = MKMapType.standard
        setEnables(hybrid: true, standard: false, satellite: true)
    }
    
    @IBAction func changeSatellite(_ sender: Any) {
        mapView.mapType = MKMapType.satellite
        setEnables(hybrid: true, standard: true, satellite: false)
    }
    
    func setEnables(hybrid: Bool, standard : Bool, satellite : Bool) {
        hybridBtn.isEnabled = hybrid
        standardBtn.isEnabled = standard
        satelliteBtn.isEnabled = satellite
    }
}
