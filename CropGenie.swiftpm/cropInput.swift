//
//  cropInput.swift
//  cropPrediction
//
//  Created by Devang Sethi on 23/01/25.
//

//
// crop.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class cropInput : MLFeatureProvider {

    /// N as integer value
    var N: Int64

    /// P as integer value
    var P: Int64

    /// temperature as double value
    var temperature: Double

    /// humidity as double value
    var humidity: Double

    /// ph as double value
    var ph: Double

    /// rainfall as double value
    var rainfall: Double

    var featureNames: Set<String> { ["N", "P", "temperature", "humidity", "ph", "rainfall"] }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "N" {
            return MLFeatureValue(int64: N)
        }
        if featureName == "P" {
            return MLFeatureValue(int64: P)
        }
        if featureName == "temperature" {
            return MLFeatureValue(double: temperature)
        }
        if featureName == "humidity" {
            return MLFeatureValue(double: humidity)
        }
        if featureName == "ph" {
            return MLFeatureValue(double: ph)
        }
        if featureName == "rainfall" {
            return MLFeatureValue(double: rainfall)
        }
        return nil
    }

    init(N: Int64, P: Int64, temperature: Double, humidity: Double, ph: Double, rainfall: Double) {
        self.N = N
        self.P = P
        self.temperature = temperature
        self.humidity = humidity
        self.ph = ph
        self.rainfall = rainfall
    }

}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class cropOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// label as string value
    var label: String {
        provider.featureValue(for: "label")!.stringValue
    }

    /// labelProbability as dictionary of strings to doubles
    var labelProbability: [String : Double] {
        provider.featureValue(for: "labelProbability")!.dictionaryValue as! [String : Double]
    }

    var featureNames: Set<String> {
        provider.featureNames
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }

    init(label: String, labelProbability: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["label" : MLFeatureValue(string: label), "labelProbability" : MLFeatureValue(dictionary: labelProbability as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class crop {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "crop", withExtension:"mlmodelc")!
    }

    /**
        Construct crop instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of crop.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `crop.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct crop instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct crop instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct crop instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<crop, Error>) -> Void) {
        load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct crop instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> crop {
        try await load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct crop instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<crop, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(crop(model: model)))
            }
        }
    }

    /**
        Construct crop instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> crop {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return crop(model: model)
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as cropInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as cropOutput
    */
    func prediction(input: cropInput) throws -> cropOutput {
        try prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as cropInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as cropOutput
    */
    func prediction(input: cropInput, options: MLPredictionOptions) throws -> cropOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return cropOutput(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as cropInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as cropOutput
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
    func prediction(input: cropInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> cropOutput {
        let outFeatures = try await model.prediction(from: input, options: options)
        return cropOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        It uses the default function if the model has multiple functions.

        - parameters:
            - N: integer value
            - P: integer value
            - temperature: double value
            - humidity: double value
            - ph: double value
            - rainfall: double value

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as cropOutput
    */
    func prediction(N: Int64, P: Int64, temperature: Double, humidity: Double, ph: Double, rainfall: Double) throws -> cropOutput {
        let input_ = cropInput(N: N, P: P, temperature: temperature, humidity: humidity, ph: ph, rainfall: rainfall)
        return try prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - inputs: the inputs to the prediction as [cropInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [cropOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    func predictions(inputs: [cropInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [cropOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [cropOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  cropOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
