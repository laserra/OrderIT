(function (lib, img, cjs) {

var p; // shortcut to reference prototypes

// stage content:
(lib.srcTimerArc = function() {
	this.initialize();

	// Layer 1
	this.dummyMc = new lib.DummyMc();
	this.dummyMc.setTransform(507,31.1,1,1,0,0,0,14,-9.9);

	this.addChild(this.dummyMc);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(493,21,28,20);


// symbols:
(lib.SecFront = function() {
	this.initialize();

	// Layer 1
	this.timerTx = new cjs.Text("30s", "bold 14px Arial Black", "#FFFFFF");
	this.timerTx.textAlign = "center";
	this.timerTx.lineHeight = 16;
	this.timerTx.lineWidth = 31;
	this.timerTx.setTransform(-1.9,-11.8);

	this.addChild(this.timerTx);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-17.4,-11.8,35,23.8);


(lib.SecBack = function() {
	this.initialize();

	// Layer 1
	this.timerTx = new cjs.Text("30s", "bold 14px Arial Black", "#E74C3C");
	this.timerTx.textAlign = "center";
	this.timerTx.lineHeight = 16;
	this.timerTx.lineWidth = 31;
	this.timerTx.setTransform(-1.9,-11.8);

	this.addChild(this.timerTx);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(-17.4,-11.8,35,23.8);


(lib.DummyMc = function() {
	this.initialize();

	// Layer 1
	this.shape = new cjs.Shape();
	this.shape.graphics.f().s("#FFFFFF").ss(1,1,1).p("ACMhjIAADHIkXAAIAAjHg");
	this.shape.setTransform(14,-9.9);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.f("#000000").s().p("AiLBkIAAjGIEWAAIAADGg");
	this.shape_1.setTransform(14,-9.9);

	this.addChild(this.shape_1,this.shape);
}).prototype = p = new cjs.Container();
p.nominalBounds = new cjs.Rectangle(0,-19.9,28,20);

})(lib = lib||{}, images = images||{}, createjs = createjs||{});
var lib, images, createjs;