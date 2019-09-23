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
        
        var annotation = Array<MKPointAnnotation>()
        
        let latitude:Array<Double> = [35.165841, 35.169536, 35.170081]
        let longitude:Array<Double> = [129.072530, 129.072826, 129.076761]
        let title:Array<String> = ["동의과학대학교", "부산여자대학교", "동의의료원"]
        let subtitle:Array<String> = ["DIT", "BWU", "DH"]
        
        let length = (latitude.count - 1)
        
        for i in 0...length {
            let marker = MKPointAnnotation()
            
            marker.coordinate.latitude = latitude[i]
            marker.coordinate.longitude = longitude[i]
            marker.title = title[i]
            marker.subtitle = subtitle[i]
            
            annotation.append(marker)
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
            
            let img = UIImageView(image: UIImage(named: "icon.png"))
                
            img.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            annotationView?.leftCalloutAccessoryView = img
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
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
