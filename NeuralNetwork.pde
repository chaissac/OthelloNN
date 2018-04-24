class NeuralNetwork {
  int inputNodes, hiddenNodes1, hiddenNodes2, outputNodes ;
  PMatrix weightsIH, weightsHH, weightsHO, biasH1, biasH2, biasO ;
  double learningRate ;
  String activationFunction ;
  final String version = "0.3";

  NeuralNetwork(int input, int hidden1, int hidden2, int output, String fn) {

    inputNodes = input ;
    hiddenNodes1 = hidden1 ;
    hiddenNodes2 = hidden2 ;
    outputNodes = output ;

    weightsIH = new PMatrix(hiddenNodes1, inputNodes);
    weightsHH = new PMatrix(hiddenNodes2, hiddenNodes1);
    weightsHO = new PMatrix(outputNodes, hiddenNodes2);
    weightsIH.randomize();
    weightsHH.randomize();
    weightsHO.randomize();

    biasH1 = new PMatrix(hiddenNodes1, 1);
    biasH2 = new PMatrix(hiddenNodes2, 1);
    biasO = new PMatrix(outputNodes, 1);
    biasH1.randomize();
    biasH2.randomize();
    biasO.randomize();

    setLearningRate(0.5);
    setActivationFunction(fn);
  }

  NeuralNetwork(NeuralNetwork n) {

    inputNodes = n.inputNodes ;
    hiddenNodes1 = n.hiddenNodes1 ;
    hiddenNodes2 = n.hiddenNodes2 ;
    outputNodes = n.outputNodes ;

    weightsIH = n.weightsIH.clone();
    weightsHH = n.weightsHH.clone();
    weightsHO = n.weightsHO.clone();

    biasH1 = n.biasH1.clone();
    biasH2 = n.biasH2.clone();
    biasO = n.biasO.clone();

    learningRate = n.learningRate;
    setActivationFunction(n.activationFunction);
  }

  void setLearningRate(double lr) {
    learningRate = lr;
  }   
  void setLearningRate(float lr) {
    learningRate = (double)lr;
  }   
  void setLearningRate(int lr) {
    learningRate = (double)lr;
  } 
  String checkFunction(String fn) {
    fn.toLowerCase();
    switch (fn) {
    case "sigmoid":
    case "tanh":
    case "step":
    case "relu":
      return fn;
    default:
      return "sigmoid";
    }
  }
  void setActivationFunction(String func) {
    activationFunction = checkFunction(func);
  }  
  String toJson() {
    JSONObject json = new JSONObject();
    json.put( "class", "NeuralNetwork" );
    json.put( "version", version );
    json.put( "inputNodes", inputNodes );
    json.put( "hiddenNodes1", hiddenNodes1 );
    json.put( "hiddenNodes2", hiddenNodes2 );
    json.put( "outputNodes", outputNodes );
    json.put( "learningRate", learningRate );
    json.put( "activationFunction", activationFunction );
    json.put( "weightsIH", weightsIH.toJson() );
    json.put( "weightsHH", weightsHH.toJson() );
    json.put( "weightsHO", weightsHO.toJson() );
    json.put( "biasH1", biasH1.toJson() );
    json.put( "biasH2", biasH2.toJson() );
    json.put( "biasO", biasO.toJson() );
    return json.toString();
  }  
  void save(String file) {
    String json = toJson();
    println(json);
  }
  Double[] predict(Double[] inputArray) {

    // Generating the Hidden1 Outputs
    PMatrix inputs = new PMatrix(inputArray);
    PMatrix hidden1 = weightsIH.clone();
    hidden1.product(inputs);
    hidden1.add(biasH1);
    // activation function!
    hidden1.map(activationFunction);

    // Generating the Hidden2 Outputs
    PMatrix hidden2 = weightsHH.clone() ;
    hidden2.product(hidden1);
    hidden2.add(biasH2);
    hidden2.map(activationFunction);

    // Generating the output's output!
    PMatrix output = weightsHO.clone() ;
    output.product(hidden2);
    output.add(biasO);
    output.map(activationFunction);

    // Sending back to the caller!
    return output.toArray();
  }

  void train(Double[] inputArray, Double[] targetArray) {

    // Generating the Hidden1 Outputs
    PMatrix inputs = new PMatrix(inputArray);
    PMatrix hidden1 = weightsIH.clone();
    hidden1.product(inputs);
    hidden1.add(biasH1);
    // activation function!
    hidden1.map(activationFunction);

    // Generating the Hidden2 Outputs
    PMatrix hidden2 = weightsHH.clone() ;
    hidden2.product(hidden1);
    hidden2.add(biasH2);
    hidden2.map(activationFunction);

    // Generating the output's output!
    PMatrix outputs = weightsHO.clone() ;
    outputs.product(hidden2);
    outputs.add(biasO);
    outputs.map(activationFunction);

    // Convert array to matrix object
    PMatrix targets = new PMatrix(targetArray);

    // Calculate the error
    // ERROR = TARGETS - OUTPUTS
    PMatrix outputErrors = targets.clone();
    outputErrors.sub(outputs);
    // Calculate gradient
    PMatrix gradient = outputs.clone();
    gradient.map("d"+activationFunction);
    gradient.mult(outputErrors);
    gradient.mult(learningRate);
    // Calculate deltas
    PMatrix hiddenT2 = hidden2.clone();
    hiddenT2.transpose();
    PMatrix weightHODeltas = gradient.clone();
    weightHODeltas.product(hiddenT2);
    // Adjust the weights by deltas
    weightsHO.add(weightHODeltas);
    // Adjust the bias by its deltas (which is just the gradients)
    biasO.add(gradient);

    // Calculate the hidden 2 layer errors
    PMatrix hidden2Errors = weightsHO.clone();
    hidden2Errors.transpose();
    hidden2Errors.product(outputErrors);
    // Calculate hidden 2 gradient
    PMatrix hidden2Gradient = hidden2.clone();
    hidden2Gradient.map("d"+activationFunction);
    hidden2Gradient.mult(hidden2Errors);
    hidden2Gradient.mult(learningRate);
    // Calculate input->hidden deltas
    PMatrix hiddenT1 = hidden1.clone();
    hiddenT1.transpose();
    PMatrix weightHHDeltas = hidden2Gradient.clone();
    weightHHDeltas.product(hiddenT1);
    // Adjust the weights by deltas
    weightsHH.add(weightHHDeltas);
    // Adjust the bias by its deltas (which is just the gradients)
    biasH2.add(hidden2Gradient);
    
    // Calculate the hidden 1 layer errors
    PMatrix hidden1Errors = weightsHO.clone();
    hidden1Errors.transpose();
    hidden1Errors.product(hidden2Errors);
    // Calculate hidden 1 gradient
    PMatrix hidden1Gradient = hidden1.clone();
    hidden1Gradient.map("d"+activationFunction);
    hidden1Gradient.mult(hidden1Errors);
    hidden1Gradient.mult(learningRate);
    // Calculate input->hidden deltas
    PMatrix inputsT = inputs.clone();
    inputs.transpose();
    PMatrix weightIHDeltas = hidden1Gradient.clone();
    weightIHDeltas.product(inputsT);
    // Adjust the weights by deltas
    weightsIH.add(weightIHDeltas);
    // Adjust the bias by its deltas (which is just the gradients)
    biasH1.add(hidden1Gradient);
  }
}