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
