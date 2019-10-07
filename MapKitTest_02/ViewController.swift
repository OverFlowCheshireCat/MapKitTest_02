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
                let latitude = (data as AnyObject).value(forKey: "latitude") as! Double
                let longitude = (data as AnyObject).value(forKey: "longitude") as! Double
                let title = (data as AnyObject).value(forKey: "title") as! String
                let subtitle = (data as AnyObject).value(forKey: "subtitle") as! String
                
                let viewPoint = ViewPoint(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: title, subtitle: subtitle)
                
                annotation.append(viewPoint)
            }
        }
        
        mapView.showAnnotations(annotation, animated: true)
            
        mapView.mapType = MKMapType.hybrid
        setEnables(hybrid: false, standard: true, satellite: true)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.orange
            annotationView?.animatesDrop = true
            
            var imageData = "DIT.jpg"
            var imageFrame = CGRect(x: 0, y: 0, width: 100, height: 30)
            
            let subtitle = annotation.subtitle
            
            if subtitle == "DIT" {
                imageData = "DIT.jpg"
                imageFrame = CGRect(x: 0, y: 0, width: 100, height: 30)
            } else if subtitle == "BWU" {
                imageData = "BWU.png"
                imageFrame = CGRect(x: 0, y: 0, width: 100, height: 30)
            } else {
                imageData = "BGU.jpeg"
                imageFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
