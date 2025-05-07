//
//  CarImg.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 3/25/19.
//  Copyright © 2019 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

//The class that has all the images in it

class CarImg {
    
    let adaptiveOne = UIImage(named: "Adaptive Front Lighting System")
    let adaptiveTwo = UIImage(named: "Adaptive Light System")
    let airSuspension = UIImage(named: "Air Suspension")
    let airBag = UIImage(named: "Air Bag Malfunction")
    let fourWheel = UIImage(named: "All Wheel4 Wheel Drive")
    let antiLock = UIImage(named: "Antilock Brake System Warning Light")
    let attention = UIImage(named: "Attention Assist")
    let aHighBeam = UIImage(named: "Auto High Beam")
    let autoStart = UIImage(named: "Auto Start-Stop Warning")
    let aebLight = UIImage(named: "Automatic Emergency Brake Light")
    let battery = UIImage(named: "BatteryCharging Light")
    let brakeAssist = UIImage(named: "Brake Assist System Light")
    let brakeFluid = UIImage(named: "Brake Fluid Light")
    let brakeHold = UIImage(named: "Brake Hold Light")
    let brakePads = UIImage(named: "Brake Pad Warning Light")
    let brakeSystem = UIImage(named: "Brake System Warning Light")
    let carRamp = UIImage(named: "Car on Ramp")
    let catWarning = UIImage(named: "Catalytic Converter Warning")
    let charge = UIImage(named: "Charge Car")
    let checkEngine = UIImage(named: "Check Engine Light")
    let childLock = UIImage(named: "Child Safety Lock")
    let aFilter = UIImage(named: "Clogged Air Filter")
    let roof = UIImage(named: "Convertible Roof Warning Light")
    let cruise = UIImage(named: "Cruise Control")
    let dRLLight = UIImage(named: "Daytime Running Lamp Light")
    let dieselFilter = UIImage(named: "Diesel Particle Filter Light")
    let differential = UIImage(named: "Differential Issues")
    let distance = UIImage(named: "Distance Warning")
    let doors = UIImage(named: "Door Ajar")
    let eco = UIImage(named: "Eco Mode")
    let lowPower = UIImage(named: "Electric Motor Power Reduced Light")
    let epc = UIImage(named: "EPC")
    let ePBrake = UIImage(named: "Electric Park Brake")
    let eMode = UIImage(named: "Electric Vehicle Mode Activated")
    let eThrottle = UIImage(named: "Electric Throttle Light")
    let engineStartFault = UIImage(named: "Engine Start System Fault")
    let coolantTemp = UIImage(named: "Coolant Warning Light")
    let exFluid = UIImage(named: "Exhaust Fluid")
    let fogLight = UIImage(named: "Fog Lights On")
    let fuelFilter = UIImage(named: "Fuel Filter Warning")
    let gasCap = UIImage(named: "Fuel Cap")
    let glowPlug = UIImage(named: "Glow Plug Indicator")
    let hazard = UIImage(named: "Hazard Lights On")
    let lightRange = UIImage(named: "Headlight Range Control")
    let highBeam = UIImage(named: "High Beam Indicator")
    let descent = UIImage(named: "Hill Descent Control")
    let hoodOpen = UIImage(named: "Hood Open")
    let hybridReady = UIImage(named: "Hybrid Ready Indicator")
    let icyConditions = UIImage(named: "Icy Road Warning Light")
    let ignitionSwitch = UIImage(named: "Ignition Switch Warning")
    let keyBattery = UIImage(named: "Key Fob Battery Low")
    let keyVehicle = UIImage(named: "Key Not In Vehicle")
    let laneDeparture = UIImage(named: "Lane Departure Warning")
    let lightOnOff = UIImage(named: "Light Out")
    let lowBeam = UIImage(named: "Low Beam Indicator Light")
    let coolant = UIImage(named: "Low Coolant")
    let lowFuel = UIImage(named: "Low Fuel Level")
    let masterLight = UIImage(named: "Master Warning Light")
    let message = UIImage(named: "Message Display")
    let oilPressure = UIImage(named: "Oil Pressure Warning Light")
    let overdrive = UIImage(named: "Overdrive Light")
    let parkAssist = UIImage(named: "Park Assist Light")
    let parkBrake = UIImage(named: "Parking Brake Light")
    let powerSteering = UIImage(named: "Power Steering Warning Light")
    let powertrain = UIImage(named: "Powertrain Fault")
    let predictLight = UIImage(named: "Predictive Efficiency Assist Light")
    let pressBrake = UIImage(named: "Press Brake Pedal")
    let pressClutch = UIImage(named: "Press Clutch Pedal")
    let rainSensor = UIImage(named: "Rain and Light Sensor")
    let read = UIImage(named: "Read Manual")
    let rearSpoiler = UIImage(named: "Rear Spoiler Warning")
    let windowDefrost = UIImage(named: "Rear Window Defrost")
    let rearLight = UIImage(named: "Stop Light Out")
    let reducePower = UIImage(named: "Reduced Power Warning")
    let seatBelt = UIImage(named: "Seat Belt Indicator")
    let securityAlert = UIImage(named: "Security Alert")
    let securityIndi = UIImage(named: "Security Indicator")
    let serviceVehicle = UIImage(named: "Service Vehicle Soon")
    let shiftUp = UIImage(named: "Shift Up")
    let sideLight = UIImage(named: "Side Light Indicator")
    let steeringLock = UIImage(named: "Steering Wheel Lock")
    let suspensionIssues = UIImage(named: "Suspension Issues")
    let tireWarning = UIImage(named: "Tire Pressure Warning Light")
    let tractionContolMal = UIImage(named: "Traction Control Malfunction")
    let tractionLight = UIImage(named: "Traction Control Light")
    let towHitch = UIImage(named: "Trailer Tow Hitch Warning")
    let transmission = UIImage(named: "Transmission Issues")
    let transTemp = UIImage(named: "Transmission Temperature")
    let washerFluid = UIImage(named: "Washer Fluid Reminder")
    let dieselWFilter = UIImage(named: "Water Fluid Filter Warning")
    let windshieldDefrost = UIImage(named: "Windshield Defrost")
    let winterMode = UIImage(named: "Winter Mode")
}


enum CarWarning: String, CaseIterable {
    case adaptiveOne = "Adaptive Front Lighting System"
    case adaptiveTwo = "Adaptive Light System"
    case airSuspension = "Air Suspension"
    case airBag = "Air Bag Malfunction"
    case fourWheel = "All Wheel4 Wheel Drive"
    case antiLock = "Antilock Brake System Warning Light"
    case attention = "Attention Assist"
    case aHighBeam = "Auto High Beam"
    case autoStart = "Auto Start-Stop Warning"
    case aebLight = "Automatic Emergency Brake Light"
    case battery = "BatteryCharging Light"
    case brakeAssist = "Brake Assist System Light"
    case brakeFluid = "Brake Fluid Light"
    case brakeHold = "Brake Hold Light"
    case brakePads = "Brake Pad Warning Light"
    case brakeSystem = "Brake System Warning Light"
    case carRamp = "Car on Ramp"
    case catWarning = "Catalytic Converter Warning"
    case charge = "Charge Car"
    case checkEngine = "Check Engine Light"
    case childLock = "Child Safety Lock"
    case aFilter = "Clogged Air Filter"
    case roof = "Convertible Roof Warning Light"
    case cruise = "Cruise Control"
    case dRLLight = "Daytime Running Lamp Light"
    case dieselFilter = "Diesel Particle Filter Light"
    case differential = "Differential Issues"
    case distance = "Distance Warning"
    case doors = "Door Ajar"
    case eco = "Eco Mode"
    case lowPower = "Electric Motor Power Reduced Light"
    case epc = "EPC"
    case ePBrake = "Electric Park Brake"
    case eMode = "Electric Vehicle Mode Activated"
    case eThrottle = "Electric Throttle Light"
    case engineStartFault = "Engine Start System Fault"
    case coolantTemp = "Coolant Warning Light"
    case exFluid = "Exhaust Fluid"
    case fogLight = "Fog Lights On"
    case fuelFilter = "Fuel Filter Warning"
    case gasCap = "Fuel Cap"
    case glowPlug = "Glow Plug Indicator"
    case hazard = "Hazard Lights On"
    case lightRange = "Headlight Range Control"
    case highBeam = "High Beam Indicator"
    case descent = "Hill Descent Control"
    case hoodOpen = "Hood Open"
    case hybridReady = "Hybrid Ready Indicator"
    case icyConditions = "Icy Road Warning Light"
    case ignitionSwitch = "Ignition Switch Warning"
    case keyBattery = "Key Fob Battery Low"
    case keyVehicle = "Key Not In Vehicle"
    case laneDeparture = "Lane Departure Warning"
    case lightOnOff = "Light Out"
    case lowBeam = "Low Beam Indicator Light"
    case coolant = "Low Coolant"
    case lowFuel = "Low Fuel Level"
    case masterLight = "Master Warning Light"
    case message = "Message Display"
    case oilPressure = "Oil Pressure Warning Light"
    case overdrive = "Overdrive Light"
    case parkAssist = "Park Assist Light"
    case parkBrake = "Parking Brake Light"
    case powerSteering = "Power Steering Warning Light"
    case powertrain = "Powertrain Fault"
    case predictLight = "Predictive Efficiency Assist Light"
    case pressBrake = "Press Brake Pedal"
    case pressClutch = "Press Clutch Pedal"
    case rainSensor = "Rain and Light Sensor"
    case read = "Read Manual"
    case rearSpoiler = "Rear Spoiler Warning"
    case windowDefrost = "Rear Window Defrost"
    case rearLight = "Stop Light Out"
    case reducePower = "Reduced Power Warning"
    case seatBelt = "Seat Belt Indicator"
    case securityAlert = "Security Alert"
    case securityIndi = "Security Indicator"
    case serviceVehicle = "Service Vehicle Soon"
    case shiftUp = "Shift Up"
    case sideLight = "Side Light Indicator"
    case steeringLock = "Steering Wheel Lock"
    case suspensionIssues = "Suspension Issues"
    case tireWarning = "Tire Pressure Warning Light"
    case tractionContolMal = "Traction Control Malfunction"
    case tractionLight = "Traction Control Light"
    case towHitch = "Trailer Tow Hitch Warning"
    case transmission = "Transmission Issues"
    case transTemp = "Transmission Temperature"
    case washerFluid = "Washer Fluid Reminder"
    case dieselWFilter = "Water Fluid Filter Warning"
    case windshieldDefrost = "Windshield Defrost"
    case winterMode = "Winter Mode"

    var image: Image {
        Image(self.rawValue)
    }

    var uiImage: UIImage? {
        UIImage(named: self.rawValue)
    }
}

/*

 "Adaptive Front Lighting System"
 "Adaptive Light System"
 "Air Suspension"
 "Air Bag Malfunction"
 "All Wheel4 Wheel Drive"
 "Antilock Brake System Warning Light"
 "Attention Assist"
 "Auto High Beam"
 "Auto Start-Stop Warning"
 "Automatic Emergency Brake Light"
 "BatteryCharging Light"
 "Brake Assist System Light"
 "Brake Fluid Light"
 "Brake Hold Light"
 "Brake Pad Warning Light"
 case brakeSystem = "Brake System Warning Light"
 case carRamp = "Car on Ramp"
 case catWarning = "Catalytic Converter Warning"
 case charge = "Charge Car"
 case checkEngine = "Check Engine Light"
 case childLock = "Child Safety Lock"
 case aFilter = "Clogged Air Filter"
 case roof = "Convertible Roof Warning Light"
 case cruise = "Cruise Control"
 case dRLLight = "Daytime Running Lamp Light"
 case dieselFilter = "Diesel Particle Filter Light"
 case differential = "Differential Issues"
 case distance = "Distance Warning"
 case doors = "Door Ajar"
 case eco = "Eco Mode"
 case lowPower = "Electric Motor Power Reduced Light"
 case epc = "EPC"
 case ePBrake = "Electric Park Brake"
 case eMode = "Electric Vehicle Mode Activated"
 case eThrottle = "Electric Throttle Light"
 case engineStartFault = "Engine Start System Fault"
 case coolantTemp = "Coolant Warning Light"
 case exFluid = "Exhaust Fluid"
 case fogLight = "Fog Lights On"
 case fuelFilter = "Fuel Filter Warning"
 case gasCap = "Fuel Cap"
 case glowPlug = "Glow Plug Indicator"
 case hazard = "Hazard Lights On"
 case lightRange = "Headlight Range Control"
 case highBeam = "High Beam Indicator"
 case descent = "Hill Descent Control"
 case hoodOpen = "Hood Open"
 case hybridReady = "Hybrid Ready Indicator"
 case icyConditions = "Icy Road Warning Light"
 case ignitionSwitch = "Ignition Switch Warning"
 case keyBattery = "Key Fob Battery Low"
 case keyVehicle = "Key Not In Vehicle"
 case laneDeparture = "Lane Departure Warning"
 case lightOnOff = "Light Out"
 case lowBeam = "Low Beam Indicator Light"
 case coolant = "Low Coolant"
 case lowFuel = "Low Fuel Level"
 case masterLight = "Master Warning Light"
 case message = "Message Display"
 case oilPressure = "Oil Pressure Warning Light"
 case overdrive = "Overdrive Light"
 case parkAssist = "Park Assist Light"
 case parkBrake = "Parking Brake Light"
 case powerSteering = "Power Steering Warning Light"
 case powertrain = "Powertrain Fault"
 case predictLight = "Predictive Efficiency Assist Light"
 case pressBrake = "Press Brake Pedal"
 case pressClutch = "Press Clutch Pedal"
 case rainSensor = "Rain and Light Sensor"
 case read = "Read Manual"
 case rearSpoiler = "Rear Spoiler Warning"
 case windowDefrost = "Rear Window Defrost"
 case rearLight = "Stop Light Out"
 case reducePower = "Reduced Power Warning"
 case seatBelt = "Seat Belt Indicator"
 case securityAlert = "Security Alert"
 case securityIndi = "Security Indicator"
 case serviceVehicle = "Service Vehicle Soon"
 case shiftUp = "Shift Up"
 case sideLight = "Side Light Indicator"
 case steeringLock = "Steering Wheel Lock"
 case suspensionIssues = "Suspension Issues"
 case tireWarning = "Tire Pressure Warning Light"
 case tractionContolMal = "Traction Control Malfunction"
 case tractionLight = "Traction Control Light"
 case towHitch = "Trailer Tow Hitch Warning"
 case transmission = "Transmission Issues"
 case transTemp = "Transmission Temperature"
 case washerFluid = "Washer Fluid Reminder"
 case dieselWFilter = "Water Fluid Filter Warning"
 case windshieldDefrost = "Windshield Defrost"
 case winterMode = "Winter Mode"
 */
