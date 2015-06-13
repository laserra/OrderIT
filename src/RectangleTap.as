package src {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import com.leonel.CustomEvent;
	import flash.geom.ColorTransform;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class RectangleTap extends MovieClip 
	{
		private var _rectXPos:Number;
		private var _rectYPos:Number;
		/*private var _screenWidth:Number;
		private var _screenHeight:Number;*/
		private var _rectWidth:Number;
		private var _rectHeight:Number;
		private var _alpha:Number;
		private var _order:uint;
		
		private var colorsArray:Array = [0xA01607, 0x12B1B, 0xDC5142, 0x7D0C00, 0x520800];
		/*private var rectColor:Number;*/
		
		private var layerMC:MovieClip = new MovieClip();
		private var tapRectangle:Shape;
		private var shadowRectangle:Shape;
		private var orderNumTf:OrderNumTxtFd = new OrderNumTxtFd();
		private var accelerometer:Accelerometer = new Accelerometer();
		/*private var angle:Number = 0;*/
		
		//private var debugTx:XposTx = new XposTx();
		
		public function RectangleTap(xPos:Number, yPos:Number, rectWidth:Number, rectHeight:Number, order:uint, alpha:Number=1):void {
			
			_rectXPos = xPos;
			_rectYPos = yPos;
			//_screenHeight = screenHeight;
			//_screenWidth = _screenWidth;
			_rectWidth = rectWidth;
			_rectHeight = rectHeight;
			
			_order = order;
			_alpha = alpha;
			
			addChild(layerMC);
			
			generateRectangle();
		}
		
		private function generateRectangle():void {
			
			shadowRectangle = new Shape();
			shadowRectangle.graphics.beginFill(0x000000, 0.1);
			shadowRectangle.graphics.drawRoundRect(0, 0, _rectWidth, _rectHeight, 25, 25);
			shadowRectangle.graphics.endFill();
			shadowRectangle.cacheAsBitmap = true;
			layerMC.addChild(shadowRectangle);
			
			tapRectangle = new Shape();
			tapRectangle.graphics.beginFill(colorsArray[3], 1);
			tapRectangle.graphics.lineStyle(3, 0xFFFFFF);
			tapRectangle.graphics.drawRoundRect(0, 0, _rectWidth, _rectHeight, 25, 25);
			tapRectangle.graphics.endFill();
			layerMC.addChild(tapRectangle);
						
			layerMC.addEventListener(MouseEvent.CLICK, rectangleTappedHandler);
			accelerometer.setRequestedUpdateInterval(50);
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerEvent);
			
			addTextField();
			
		}
		
		private function addTextField():void 
		{	
			orderNumTf.ordNumTxt.text = String(_order);
			orderNumTf.x = orderNumTf.y = _rectWidth/2;
			/*orderNumTf.x = _rectWidth / 2 - orderNumTf.width / 2;
			orderNumTf.y = _rectHeight / 2 - orderNumTf.height / 2 - 14;*/
			layerMC.addChild(orderNumTf);
		}
		
		
		
		private function rectangleTappedHandler(e:MouseEvent):void 
		{
			layerMC.removeEventListener(MouseEvent.CLICK, rectangleTappedHandler);
			accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometerEvent);
			//dispatchEvent(new CustomEvent(CustomEvent.RECTANGLE_TAPPED));
		}
		
		
		
		public function getOrderNumber():uint {
			return _order;
		}
		
		public function get rectWidth():Number 
		{
			return _rectWidth;
		}
		
		public function set rectWidth(value:Number):void 
		{
			_rectWidth = value;
		}
		
		public function get rectHeight():Number 
		{
			return _rectHeight;
		}
		
		public function set rectHeight(value:Number):void 
		{
			_rectHeight = value;
		}
		
		public function get rectXPos():Number 
		{
			return _rectXPos;
		}
		
		public function set rectXPos(value:Number):void 
		{
			_rectXPos = value;
		}
		
		public function get rectYPos():Number 
		{
			return _rectYPos;
		}
		
		public function set rectYPos(value:Number):void 
		{
			_rectYPos = value;
		}
		
		public function get order():uint 
		{
			return _order;
		}
		
		public function removeTextField():void {
			removeChild(orderNumTf);
		}
		
		public function deleteRectangle():void {
			removeChild(tapRectangle);
		}
		
		public function resize(size:Number, screenWidth:Number):void {
			_rectWidth = size;
			_rectHeight = size;
			
			orderNumTf.x = orderNumTf.y = size / 2;
			orderNumTf.scaleX = orderNumTf.scaleY = ((85 * screenWidth) / 480) / 85;
			
			redrawRectangle();
		}
		
		private function redrawRectangle():void 
		{
			layerMC.removeChild(tapRectangle);
			tapRectangle = null;
			
			shadowRectangle.width = _rectWidth;
			shadowRectangle.height = _rectHeight;
			
			tapRectangle = new Shape();
			tapRectangle.graphics.beginFill(colorsArray[3], 1);
			tapRectangle.graphics.lineStyle(3, 0xFFFFFF);
			tapRectangle.graphics.drawRoundRect(0, 0, _rectWidth, _rectHeight, 25, 25);
			tapRectangle.graphics.endFill();
			layerMC.addChild(tapRectangle);
			
			addListeners();
			
			layerMC.swapChildren(tapRectangle, orderNumTf);
		}
		
		public function changeTapColor():void {
			var rectangleColorTransform:ColorTransform = new ColorTransform();
			rectangleColorTransform.color = colorsArray[2];
			tapRectangle.transform.colorTransform = rectangleColorTransform;
		}
		
		public function changeRectangleColor():void {
			orderNumTf.visible = false;
			var rectangleColorTransform:ColorTransform = new ColorTransform();
			rectangleColorTransform.color = colorsArray[4];
			tapRectangle.transform.colorTransform = rectangleColorTransform;
		}
		
		public function showOrderNum():void {
			orderNumTf.visible = true;
		}
		
		public function addListeners():void {
			layerMC.addEventListener(MouseEvent.CLICK, rectangleTappedHandler);
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerEvent);
		}
		
		private function onAccelerometerEvent(e:AccelerometerEvent):void 
		{	
			var aX:Number = e.accelerationX * 25;
			var aY:Number = e.accelerationY * 25;
			
			shadowRectangle.x = aX;
			shadowRectangle.y = aY;
			
		}
			
		public function resetRectangle():void {
			tapRectangle.graphics.beginFill(colorsArray[3], 1);
			tapRectangle.graphics.lineStyle(3, 0xFFFFFF);
			tapRectangle.graphics.drawRoundRect(0, 0, _rectWidth, _rectHeight, 25, 25);
			tapRectangle.graphics.endFill();
			
			showOrderNum();
			addListeners();
		}
		
		public function setColorArray(colors:Array):void {
			colorsArray = null;
			colorsArray = colors;
		}
	}
}