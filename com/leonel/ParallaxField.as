package com.leonel
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	
	public class ParallaxField extends MovieClip
	{
		// settings & vars
		//private var acceleration:Number = .25;
		
		private var starBox:Sprite;		
		private var starsArray:Array = [];
		private var starArrayLength:int;
		
		private static var STAR_SMALL_UP:String = "smallup";
		private static var STAR_NORMAL_UP:String = "normalup";
		private static var STAR_LARGE_UP:String = "largeup";
		/*private static var STAR_SMALL_DOWN:String = "smalldown";
		private static var STAR_NORMAL_DOWN:String = "normaldown";
		private static var STAR_LARGE_DOWN:String = "largedown";*/	
		
		private var pathToContainer:MovieClip;
		
		private var containerX:int;
		private var containerY:int;
		
		private var containerWidth:int;
		private var containerHeight:int;
		
		private var speedX:Number;
		private var speedY:Number;
		
		private var isStarted:Boolean = false;
		
		/*private var _upPressed:Boolean = false;
		private var _downPressed:Boolean = false;
		private var _leftPressed:Boolean = false;
		private var _rightPressed:Boolean = false;*/
		
		/**
		 * Creates Parallax Field
		 * 
		 * @param	$container		The container that holds all our starfield assets. Must be created and added to stage before being used here.
		 * @param	$x				The X position of our starfield.
		 * @param	$y				The Y position of our starfield.
		 * @param	$width			The width of our starfield.
		 * @param	height			The height of our starfield.
		 * @param	$numberOfStars	Number of stars to create.
		 * @param	$speedX			The initial X speed of our starfield.
		 * @param	$speedY			The initial Y speed of our starfield.
		 * @param	direction		Paralax direction.
		 */
		//public function createField($container:MovieClip, $x:int, $y:int, $width:int, $height:int, $numberOfStars:int, $speedX:int, $speedY:int, $direction:String, $color:Number):void
		public function createField($x:int, $y:int, $width:int, $height:int, $numberOfStars:int, $speedX:int, $speedY:int):void
		{
			trace("createField");
			
			// save property references
			//pathToContainer = $container;
			
			containerX = $x;
			containerY = $y;
			
			containerWidth = $width;
			containerHeight = $height;
			
			speedX = $speedX;
			speedY = $speedY;
			
			// create everything
			createStarBox();
			

			addStars($numberOfStars, "smallup");
			addStars($numberOfStars, "normalup");
			addStars($numberOfStars, "largeup");

			
			// enable
			enable();
		}
		
		/**
		 * Adds stars to star container
		 * 
		 * @param	$numberOfStars 	Amount of stars to create
		 */
		public function addStars($numberOfStars:int, $type:String):void
		{			
			trace("Adding stars...");
			
			var newNumberOfStars:Number;
			var graphic:String;
			var speedModifier:Number;
			var alphaModifier:Number;
			var ClassReference:Class;
			
			// set star properties
			if ($type == STAR_LARGE_UP)
			{
				graphic =  "StarLargeUp";
				speedModifier = 1;
				alphaModifier = 0.2;
				newNumberOfStars = Math.round($numberOfStars * .30);				
			}
			else if ($type == STAR_NORMAL_UP)
			{
				graphic = "StarNormalUp";
				speedModifier = .66;
				alphaModifier = 0.4;
				newNumberOfStars = Math.round($numberOfStars * .60);
			}
			else if ($type == STAR_SMALL_UP)
			{
				newNumberOfStars = Math.round($numberOfStars * 1);
				graphic = "StarSmallUp";
				speedModifier = .33;
				alphaModifier = 0.6;
			}
			
			
			trace(" type:   " + graphic);
			trace(" amount: " + newNumberOfStars);
			
			// run a for loop to create new stars (based on numberOfStars)
			var i:int;
			for (i = 0; i < newNumberOfStars; i++) 
			{
				// get class via string name
				ClassReference = getDefinitionByName(graphic) as Class;
				
				// create class
				var tempStar:MovieClip = new ClassReference();		
				
				// set random starting position
				tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;
				tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;
				
				// give the star its own speed modifier
				tempStar.speedModifier = speedModifier;
				tempStar.alpha = alphaModifier;
				tempStar.cacheAsBitmap = true;
				
				/*var arrowColorTransform:ColorTransform = new ColorTransform();
				arrowColorTransform.color = _color;
				tempStar.transform.colorTransform = arrowColorTransform;*/
			
				// add new star to array that tracks all stars
				starsArray.push(tempStar);
				
				// add to display list
				//pathToContainer.addChild(tempStar);
				this.addChild(tempStar);
			}
			
			trace("Stars Added \n");
		}
		
		/**
		 * Activates parallax effect
		 */
		public function enable():void
		{
			if (!isStarted)
			{
				//trace("Starting parallax effect...");
				isStarted = true;
				
				// add enter frame
				this.addEventListener(Event.ENTER_FRAME, gameLoop);
			}
			else
			{
				trace("Parallax effect already running.");
			}
			
		}
		
		/**
		 * Disables parallax effect
		 */
		public function disable():void
		{
			if (isStarted)
			{
				//trace("Stopping parallax effect...");
				isStarted = false;
				
				// remove enter frame
				this.removeEventListener(Event.ENTER_FRAME, gameLoop);
			}
			else
			{
				trace("Parallax effect is not running.");
			}
			
		}
		
		/*************************************************************************/
		
		/**
		 * @private
		 * Creates a star container
		 */
		private function createStarBox():void
		{
			/*trace("Creating star container...");
			trace(" path:   " + pathToContainer);
			trace(" x:      " + containerX);
			trace(" y:      " + containerY);
			trace(" width:  " + containerWidth);
			trace(" height: " + containerHeight);*/
			
			// create new container for stars
			starBox = new Sprite();			
			starBox.graphics.beginFill(0x000000);
			
			// set container's properties			
			starBox.x = containerX;
			starBox.y = containerY;
			starBox.width = containerWidth;
			starBox.height = containerHeight;
			
			// create mask
			var starBoxMask:Sprite = new Sprite();
			starBoxMask.graphics.beginFill(0xFF0000);
			starBoxMask.graphics.drawRect(containerX, containerY, containerWidth, containerHeight);
			this.addChild(starBoxMask);
			
			// Apply mask
			starBox.mask = starBoxMask;
			
			// add starBox to stage
			this.addChild(starBox);
			
			trace(" Container Created \n");
		}
		
		/**
		 * @private 
		 * This function is executed every frame.
		 */
		private function gameLoop(event:Event):void 
		{			
			updateStars();
		}	
		
		/**
		 * @private
		 * This function updates all the objects in the stars array
		 */
		private function updateStars():void
		{
			// setting the array length variable outside of the for loop improves speed
			starArrayLength = starsArray.length;
			
			// setting the "tempStar" variable outside of the for loop improves speed
			var tempStar:MovieClip;
			
			// setting the "i" variable outside of the for loop improves speed
			var i:int;			
			
			// run for loop
			for(i = 0; i < starArrayLength; i++)
			{
				tempStar = starsArray[i];
				//tempStar.x += speedX * tempStar.speedModifier;
				tempStar.y += speedY * tempStar.speedModifier;
				
				//Star boundres
				//check X boudries
				if (tempStar.x >= containerWidth - tempStar.width + containerX) 
				{
					//outside boundry, move to other side of container
					//tempStar.x = containerX;
					tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;
					
				}
				else if (tempStar.x <= containerX) 
				{
					//outside boundry, move to other side of container
					//tempStar.x = containerWidth + containerX - tempStar.width;
					tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;
				}
				
				//check Y boudries
				if (tempStar.y >= containerHeight - tempStar.height + containerY)
				{
					//outside boundry, move to other side of container
					//tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;
					tempStar.y = containerY;
				}
				else if (tempStar.y <= containerY) 
				{
					//outside boundry, move to other side of container
					//tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;
					tempStar.y = containerHeight + containerY - tempStar.height;
				}
			}
		}
		
	}
	
}