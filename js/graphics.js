document.getElementById("tmp").innerHTML = "reached";

var mvMatrix;
var vertexPositionAttribute;
var perspectiveMatrix;

function start() {
  /*
  // get all the canvas elements
  var canvasList = document.getElementsByTagName("canvas");

  for(curIter = 0; curIter < canvasList.length; curIter++)
  {
  	// CHECK: print out current iter
  	document.getElementById("tmp").innerHTML = curIter.toString();

  	// get webGL context
  	var canvas = canvasList[curIter];
  	*/
  var canvas = document.getElementById("dna_view");
  var gl = initWebGL(canvas);

  if (gl) {
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clearDepth(1.0);
    gl.enable(gl.CULL_FACE);
    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LEQUAL);

    var shaderProgram = initShaders(gl);
    var squareVerticesBuffer = initBuffers(gl);

    var positionLocation =
      gl.getAttribLocation(shaderProgram, "a_position");
    var colorLocation =
      gl.getAttribLocation(shaderProgram, "a_color");

    var matrixLocation =
      gl.getUniformLocation(shaderProgram, "u_matrix");
    setInterval(
      drawScene(canvas,
        gl,
        squareVerticesBuffer,
        vertexPositionAttribute,
        shaderProgram),
      5);
  } else {
    alert("gl is null");
  }
  //}
}

function initWebGL(canvas) {
  var gl = null;
  try {
    gl = canvas.getContext("webgl") ||
      canvas.getContext("experimental-webgl");
  } catch (e) {}

  if (!gl) {
    alert("Unable to initialize WebGL." +
      "Your browser may not support it.");
    gl = null;
  }

  return gl;
}

function initShaders(gl) {
  var fragmentShader = getShader(gl, "shader-fs");
  var vertexShader = getShader(gl, "shader-vs");

  // create the shader program
  var shaderProgram = gl.createProgram();
  gl.attachShader(shaderProgram, vertexShader);
  gl.attachShader(shaderProgram, fragmentShader);
  gl.linkProgram(shaderProgram);

  // if creating the shader program failed, alert
  if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
    alert("Unable to initialize the shader program.");
  }

  gl.useProgram(shaderProgram);
  vertexPositionAttribute =
    gl.getAttribLocation(shaderProgram, "aVertexPosition");
  gl.enableVertexAttribArray(vertexPositionAttribute);

  return shaderProgram;
}

function getShader(gl, id) {
  // get element from the DOM if it exists
  var shaderScript = document.getElementById(id);
  if (!shaderScript) {
    return null;
  }

  var source = "";
  var currentChild = shaderScript.firstChild;

  // create a string from the script source
  while (currentChild) {
    if (currentChild.nodeType == currentChild.TEXT_NODE) {
      source += currentChild.textContent;
    }
    currentChild = currentChild.nextSibling;
  }

  // create appropriate shader type
  var shader;
  if (shaderScript.type == "x-shader/x-fragment") {
    shader = gl.createShader(gl.FRAGMENT_SHADER);
  } else if (shaderScript.type == "x-shader/x-vertex") {
    shader = gl.createShader(gl.VERTEX_SHADER);
  } else {
    // unknown shader type
    return null;
  }

  // send source to shader object
  gl.shaderSource(shader, source);

  // compile the shader program
  gl.compileShader(shader);

  // see if compiled successfully
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    alert("Error occured compiling shaders: " +
      gl.getShaderInfoLog(shader));
    return null;
  }

  return shader;
}

function initBuffers(gl) {
  var squareVerticesBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVerticesBuffer);
  var vertices = [
    1.0, 1.0, 0.0, -1.0, 1.0, 0.0,
    1.0, -1.0, 0.0, -1.0, -1.0, 0.0
  ];

  gl.bufferData(
    gl.ARRAY_BUFFER,
    new Float32Array(vertices),
    gl.STATIC_DRAW);

  return squareVerticesBuffer;
}

function drawScene(canvas,
  gl,
  squareVerticesBuffer,
  vertexPositionAttribute,
  shaderProgram) {
  // clear context to background color
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  perspectiveMatrix =
    makePerspective(45, canvas.width / canvas.height, 0.1, 100.0);
  loadIdentity();
  mvTranslate([-0.0, 0.0, -6.0]);

  gl.bindBuffer(gl.ARRAY_BUFFER, squareVerticesBuffer);
  gl.vertexAttribPointer(vertexPositionAttribute,
    3,
    gl.FLOAT,
    false,
    0,
    0);
  setMatrixUniforms(shaderProgram);
  gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
}

function loadIdentity() {
  mvMatrix = Matrix.I(4);
}

function multMatrix(m) {
  mvMatrix = mvMatrix.x(m);
}

function mvTranslate(v) {
  multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4());
}

function setMatrixUniforms(shaderProgram) {
  var pUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
  gl.uniformMatrix4fv(pUniform, false,
    new Float32Array(perspectiveMatrix.flatten()));

  var mvUniform =
    gl.getUniformLocation(shaderProgram, "uMVMatrix");
  gl.uniformMatrix4fv(mvUniform, false,
    new Float32Array(mvMatrix.flatten()));
}
