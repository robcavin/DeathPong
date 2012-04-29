//
//  BBJViewController.m
//  Death Pong
//
//  Created by Robert Cavin on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBJViewController.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_LIGHT_POS,
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_MODELVIEW_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[432] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         -1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          -1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         -1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, -1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, 1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    /*0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,*/
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 1.0f,



    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f,  1.0f,
     -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
     0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
     0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
     -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
     -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
   /*0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 1.0f*/


};

@interface BBJViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    float _x_rotation;
    float _y_rotation;
    float _x_translation;
    float _y_translation;
    
    float accelX;
    float accelY;
    float accelZ;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;

    GLKMatrix4 _ball_modelViewProjectionMatrix;
    GLKMatrix4 _ball_modelViewMatrix;
    GLKMatrix3 _ball_normalMatrix;

    GLKVector3 _ballPos;
    GLKVector3 _ballVel;
    GLKVector3 _ballAccel;

    GLKVector3 _playerPos;
    GLKVector3 _playerVel;

    GLKVector3 _lightPos;

}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) CMMotionManager *motionManager;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation BBJViewController

@synthesize context = _context;
@synthesize effect = _effect;
@synthesize motionManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    motionManager = [[CMMotionManager alloc] init]; // motionManager is an instance variable
    motionManager.accelerometerUpdateInterval = 0.01; // 100Hz    
    [motionManager startAccelerometerUpdates];
    
    [self setupGL];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    _lightPos = GLKVector3Make(0.0, 0.0, -0.5);
    
    _ballPos = GLKVector3Make(0.0, 0.0, 0.0);
    _ballVel = GLKVector3Make(-0.2, 0.3, -1.0);

    _playerPos = GLKVector3Make(0.0, 0.0, 0.0);
    _playerVel = GLKVector3Make(0.0, 0.0, 0.0);

    _x_translation = 0.0;
    _y_translation = 0.0;
    
    accelX = accelY = accelZ = 0;
    
    //_ballAccel = GLKVector3Make(-0.3, 0.2, -1);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

#define kFilteringFactor 0.9

- (void)update
{
    
    

    static int first = 1;
    
    CMAccelerometerData* data = motionManager.accelerometerData;

    // Subtract the low-pass value from the current value to get a simplified high-pass filter

    if (first) {
        accelX = data.acceleration.x;// - ( (data.acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor)) );
        accelY = data.acceleration.y;// - ( (data.acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor)) );
        accelZ = data.acceleration.z;// - ( (data.acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor)) );
        first = 0;
    }
    
    GLKVector3 playerAccel = GLKVector3Make(10*(data.acceleration.x - accelX),10*(data.acceleration.y - accelY),10*(data.acceleration.z - accelZ));

    accelX = data.acceleration.x;// - ( (data.acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor)) );
    accelY = data.acceleration.y;// - ( (data.acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor)) );
    accelZ = data.acceleration.z;// - ( (data.acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor)) );

    
    NSLog(@"%f %f %f", playerAccel.x, playerAccel.y, playerAccel.z);
    _playerPos = GLKVector3Add(_playerPos,
                             GLKVector3Add(GLKVector3MultiplyScalar(_playerVel, self.timeSinceLastUpdate),
                                           GLKVector3MultiplyScalar(playerAccel, self.timeSinceLastUpdate*self.timeSinceLastUpdate)));
    
    _playerVel = GLKVector3Add(GLKVector3MultiplyScalar(_playerVel,1.0),
                             GLKVector3MultiplyScalar(playerAccel, self.timeSinceLastUpdate));
    
    
    if (_playerPos.x < -0.5) {_playerPos.x = -0.5; _playerVel.x = 0;}
    if (_playerPos.x > 0.5) {_playerPos.x = 0.5; _playerVel.x = 0;}
    if (_playerPos.y < -0.5) {_playerPos.y = -0.5; _playerVel.y = 0;}
    if (_playerPos.y > 0.5) {_playerPos.y = 0.5; _playerVel.y = 0;}
    if (_playerPos.z < -0.5) {_playerPos.z = -0.5; _playerVel.z = 0;}
    if (_playerPos.z > 0.5) {_playerPos.z = 0.5; _playerVel.z = 0;}
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    //self.effect.transform.projectionMatrix = projectionMatrix;

    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeScale(1.0, 1.0, 1.0);
    
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix,_x_rotation, 0.0f, 1.0f, 0.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _y_rotation, 1.0f, 0.0f, 0.0f);
    baseModelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, _playerPos.x, _playerPos.y, -1.0f);

    //baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 0.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    //GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    //modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    //self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Compute the model view matrix for the object rendered with ES2
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);

    //self.effect.transform.modelviewMatrix = modelViewMatrix;

    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    _modelViewMatrix = modelViewMatrix;
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    //_rotation += self.timeSinceLastUpdate * 0.5f;


    // New code for ball
    //GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    
    
    _ballPos = GLKVector3Add(_ballPos,
                             GLKVector3Add(GLKVector3MultiplyScalar(_ballVel, self.timeSinceLastUpdate),
                                            GLKVector3MultiplyScalar(_ballAccel, self.timeSinceLastUpdate*self.timeSinceLastUpdate)));
    
    _ballVel = GLKVector3Add(GLKVector3MultiplyScalar(_ballVel,1.0),
                             GLKVector3MultiplyScalar(_ballAccel, self.timeSinceLastUpdate));

    _ballAccel = GLKVector3Make(0.0, 0.0, 0.0);
    
    if (_ballPos.x < -0.5) {
        _ballVel.x = -_ballVel.x;
        _ballPos.x = -0.5;
    }
    
    if (_ballPos.x > 0.5) {
        _ballVel.x = -_ballVel.x;
        _ballPos.x = 0.5;
    }
    
    if (_ballPos.y < -0.5) {
        _ballVel.y = -_ballVel.y;
        _ballPos.y = -0.5;
    }
    
    if (_ballPos.y > 0.5) {
        _ballVel.y = -_ballVel.y;
        _ballPos.y = 0.5;
    }
    
    if (_ballPos.z < -0.5) {
        _ballVel.z = -_ballVel.z;
        _ballPos.z = -0.5;
    }
    
    if (_ballPos.z > 0.5) {
        _ballVel.z = -_ballVel.z;
        _ballPos.z = 0.5;
    }
    
    modelViewMatrix = GLKMatrix4MakeTranslation(playerAccel.x, playerAccel.y, playerAccel.z);    
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.05, 0.05, 0.05);

    //modelViewMatrix = GLKMatrix4MakeScale(0.05, 0.05, 0.05);
    //modelViewMatrix = GLKMatrix4Translate(modelViewMatrix,_ballPos.x, _ballPos.y, _ballPos.z);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
/*    NSLog(@"%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f",
          modelViewMatrix.m00, modelViewMatrix.m01, modelViewMatrix.m02, modelViewMatrix.m03,
          modelViewMatrix.m10, modelViewMatrix.m11,modelViewMatrix.m12, modelViewMatrix.m13,
          modelViewMatrix.m20, modelViewMatrix.m21, modelViewMatrix.m22, modelViewMatrix.m23,
          modelViewMatrix.m30, modelViewMatrix.m31, modelViewMatrix.m32, modelViewMatrix.m33);
*/
    _ball_normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);    
    _ball_modelViewMatrix = modelViewMatrix;
    _ball_modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    GLKVector4 transformedBallPos = GLKMatrix4MultiplyVector4(_ball_modelViewMatrix, GLKVector4MakeWithVector3(_ballPos, 1.0));
    
    _lightPos = GLKVector3Make(transformedBallPos.x / transformedBallPos.w,
                               transformedBallPos.y / transformedBallPos.w,
                               transformedBallPos.z / transformedBallPos.w);
    
    //NSLog(@"%f %f %f", transformedBallPos.x, transformedBallPos.y, transformedBallPos.z);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    //[self.effect prepareToDraw];
    
    //glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);

    glUniform3fv(uniforms[UNIFORM_LIGHT_POS], 1, _lightPos.v);

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEW_MATRIX], 1, 0, _modelViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 30);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _ball_modelViewProjectionMatrix.m);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEW_MATRIX], 1, 0, _ball_modelViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _ball_normalMatrix.m);
    glDrawArrays(GL_TRIANGLES, 30, 66);
    
}

#pragma mark -  OpenGL ES 2 shader compilation
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint curLoc, prevLoc;
    CGPoint delta;
    for (UITouch* touch in touches) {
        curLoc = [touch locationInView:self.view];
        prevLoc = [touch previousLocationInView:self.view];
        delta = CGPointMake((curLoc.x - prevLoc.x),(curLoc.y - prevLoc.y));
        
        _x_rotation = 0.25*((curLoc.x - self.view.center.x) / self.view.bounds.size.width) * M_PI;
        _y_rotation = 0.25*((curLoc.y - self.view.center.y) / self.view.bounds.size.height) * M_PI;
        
        _x_translation = ((curLoc.x - self.view.center.x) / self.view.bounds.size.width);
        _y_translation = -((curLoc.y - self.view.center.y) / self.view.bounds.size.height);
        
    }
}


#define kAccelerometerFrequency        60.0 //Hz
-(void)configureAccelerometer
{
    UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
    theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
    
    theAccelerometer.delegate = self;
    // Delegate events begin immediately.
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue x, y, z;
    x = acceleration.x;
    y = acceleration.y;
    z = acceleration.z;
    
    // Do something with the values.
}


- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_MODELVIEW_MATRIX] = glGetUniformLocation(_program, "modelViewMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_LIGHT_POS] = glGetUniformLocation(_program, "lightPos");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
