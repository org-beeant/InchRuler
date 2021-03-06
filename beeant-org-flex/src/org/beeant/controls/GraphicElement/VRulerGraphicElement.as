package org.beeant.controls.GraphicElement
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	
	import spark.primitives.supportClasses.FilledElement;

	/**
	 * Draws a Vertical Tick Lines in the Inch Ruler
	 */ 	
	public class VRulerGraphicElement extends FilledElement
	{
		/**
		 * Commands to draw the tick lines 
		 */
		private var _commands:Vector.<int> = new Vector.<int>();
		
		/**
		 * Data to draw the tick lines 
		 */
		private var _data:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Commands to draw the tick lines 
		 */
		private var _commandsPointer:Vector.<int> = new Vector.<int>();
		
		/**
		 * Data to draw the tick lines 
		 */
		private var _dataPointer:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Index for drawing commands 
		 */
		private var _ci:Number = 0;
		
		/**
		 * Index for data commands 
		 */
		private var _di:Number = 0;
		
		/**
		 * Number of divisions 
		 */
		private var _divisions:Number = 23;
		
		/**
		 * Number of subdivisions 
		 */
		private var _subdivisions:int = 4;
		
		/**
		 * Ratio of line height, subdivisions to division 
		 */
		private var _subdivisionToDivisionLineHeightRatio:Number = .50;
		
		/**
		 * Weight of stroke 
		 */
		private var _strokeWeight:int = 1;
		
		/**
		 * Graphic Element
		 */
		private var graphic:Graphics;
		
		public function VRulerGraphicElement()
		{
			super();
		}
		
		//------------------------------------------------------------------
		//
		// Properties
		//
		//------------------------------------------------------------------
		
		/**
		 * Number of divisions 
		 */
		public function get divisions():Number
		{
			return _divisions;
		}
		
		public function set divisions(value:Number):void
		{
			_divisions = value;
			invalidateDisplayList();
		}
		
		/**
		 * Number of subdivision 
		 */
		public function get subdivisions():int
		{
			return _subdivisions;
		}
		
		public function set subdivisions(value:int):void
		{
			_subdivisions = Math.max(1, value);
			invalidateDisplayList();
		}
		
		/**
		 * Ratio of line height, subdivision to division 
		 */
		public function get subdivisionToDivisionLineHeightRatio():Number
		{
			return _subdivisionToDivisionLineHeightRatio;
		}
		
		public function set subdivisionToDivisionLineHeightRatio(value:Number):void
		{
			_subdivisionToDivisionLineHeightRatio = value;
		}
		
		/**
		 * Stroke weights 
		 */
		public function get strokeWeight():int
		{
			return _strokeWeight;
		}
		
		/**
		 * @private
		 */
		public function set strokeWeight(value:int):void
		{
			_strokeWeight = value;
		}
		
		//------------------------------------------------------------------
		//
		// Drawing
		//
		//------------------------------------------------------------------
		
		/**
		 * Draw the ruler 
		 * 
		 * TODO: logic to actually reuse commands and data if nothing has changed
		 * @param w width of ruler
		 * @param h height of ruler
		 * 
		 */
		override protected function draw(g:Graphics):void
		{
			graphic = g;
			drawRuler();
		}
		
		private function drawRuler():void
		{
			//get root coordinates for this graphic element relative to the drawnDisplayObject
			//coordinates of this graphical element must be taken into account
			//coordinates to draw to relative to the drawnDisplayObject might not start at 0, 0 but at drawX, drawY
			//since display object might be shared
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			//reset indexes for drawing commands
			_ci = 0;
			_di = 0;
			
			//height of subdivision tickline
			var sdth:Number = width * subdivisionToDivisionLineHeightRatio;
			
			//DivisionTickDistance
			var dtd:Number = height/(divisions);
			
			//subdivision tick line distance
			var sdtd:Number = dtd/subdivisions;
			
			//x inc
			var tx:Number = 0;
			
			//current height of tickline to draw
			var th:Number = height;
			
			var cntr:Number = 0;
			
			var ticks:Number = (divisions) * subdivisions;
			
			//the bottom line
			_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
			_data[_di++] = gy + width;
			_data[_di++] = gx;
			
			_commands[_ci++] = GraphicsPathCommand.LINE_TO;
			_data[_di++] = gx + width;
			_data[_di++] = gy + height;
			
			//prepare drawing commands for tick lines
			while (cntr <= ticks) {
				
				if (cntr % subdivisions == 0) 
					th = 0;
				else if(cntr % subdivisions == 5)
					th = sdth / 2;
				else 
					th = sdth;
				
				//Tick
				_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
				_data[_di++] = gx + width;
				_data[_di++] = gy + tx;
				
				
				_commands[_ci++] = GraphicsPathCommand.LINE_TO;
				_data[_di++] = gx + th;
				_data[_di++] = gy + tx;
				
				tx += sdtd;
				cntr++;
			}
			
			//since we are reusing command and data vectors over multiple passses clear out unnecessary data from former pass
			//TODO. Actually make caching work so that if no parameters changed, chached drawing is enabled.
			if (_ci != _commands.length)
			{
				_commands.splice(_ci, _commands.length - _ci);
				_data.splice(_di, _data.length - _di);
			}
			
			graphic.drawRect(gx, gy, width, height);
			
			graphic.endFill();
			graphic.lineStyle(strokeWeight, 0x000000);
			graphic.drawPath(_commands, _data);
		}
		
		//------------------------------------------------------------------
		//
		// Pointer Showing the Mouse position in the HRuler
		//
		//------------------------------------------------------------------
		/**
		 * pointer shows the mouse location in the Ruler Element
		 */ 
		public function mouseMoveHandle(yValue:Number):void
		{
			graphic.clear();
			drawRuler();
			_ci = 0;_di = 0;
			
			_commandsPointer[_ci++] = GraphicsPathCommand.MOVE_TO;
			_dataPointer[_di++] = width;
			_dataPointer[_di++] = yValue;
			
			_commandsPointer[_ci++] = GraphicsPathCommand.LINE_TO;
			_dataPointer[_di++] = 0;
			_dataPointer[_di++] = yValue;
			
			graphic.lineStyle(strokeWeight * 2, 0xFF0000);
			graphic.drawPath(_commandsPointer, _dataPointer);
		}
	}
}