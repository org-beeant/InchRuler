package org.beeant.controls.RuleComponent
{
	import flash.system.Capabilities;
	
	import flashx.textLayout.formats.Float;
	
	import mx.core.IFactory;
	
	import org.beeant.controls.GraphicElement.HRulerGraphicElement;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class HRule extends SkinnableComponent
	{
		public static var LABEL_PADDING:Number = 5;
				
		public static var DEFAULT_LABEL_DISTANCE:Number;
		
		if(flash.system.Capabilities.os == "mac")
		{
			DEFAULT_LABEL_DISTANCE = 75;
		}
		else
		{
			DEFAULT_LABEL_DISTANCE = 96;
		}
		
		/**
		 * Dynamic skin part for a label.
		 * These are created at runtime based on the array of labels submitted 
		 */
		[SkinPart(required="false")]
		public var tickLineLabel:IFactory;
		
		/**
		 * References to the labels created at rt 
		 */
		public var tickLineLabelInstances:Array;
		
		/**
		 * A SpriteVisualElement that draws the tick lines 
		 */
		[SkinPart(required="true")]
		public var ruler:HRulerGraphicElement;
		
		[SkinPart(required="true")]
		public var rulerGroup:Group;
		
		/**
		 * Labels to display
		 */
		private var _labels:Array;
		
		/**
		 * Flag to indicate label change 
		 */
		private var _bLabelsChanged:Boolean;
		
		/**
		 * Distance of labels 
		 */
		private var _labelDistance:Number = DEFAULT_LABEL_DISTANCE;
		
		private var _bLabelDistanceChanged:Boolean;
		
		/**
		 * Number of subdivisions required 
		 */
		private var _subdivisions:int = 2;
		
		/**
		 * Flag to indicate that number of subdivision changed 
		 */
		private var _bSubdivisionsChanged:Boolean;
		
		public var isFloatVaue:Boolean;
		
		public var extraWidth:Float;
		
		public function HRule()
		{
			super();
			//			labelDistance = width / 10;			
		}
		
		/**
		 * Number of subdivisons to draw between labels 
		 * @return 
		 * 
		 */
		public function get subdivisions():int
		{
			return _subdivisions;
		}
		
		public function set subdivisions(value:int):void
		{
			if(_subdivisions != value)
			{
				_subdivisions = value;
				_bSubdivisionsChanged = true;
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		/**
		 * The distance between two labels 
		 * @return 
		 * 
		 */
		public function get labelDistance():Number
		{
			return _labelDistance;
		}
		
		public function set labelDistance(value:Number):void
		{
			if (_labelDistance != value) {
				_labelDistance = value;
				_bLabelDistanceChanged = true;
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		/**
		 * An array of String values that hold the labels 
		 * @param values
		 * 
		 */
		public function set labels(values:Array):void 
		{
			if (_labels != values)
			{
				_labels = values;
				_bLabelsChanged = true;
				invalidateSize();
				invalidateProperties();
				invalidateDisplayList();
			}
		}
				
		//--------------------------------------------------------------------
		//
		// Overriden functions and validation functions
		//
		//--------------------------------------------------------------------
		
		/**
		 * Overriden. Add mouse listener to the entire skin 
		 */
		override protected function attachSkin():void 
		{
			super.attachSkin();
		}
		
		override protected function detachSkin():void
		{
			super.detachSkin();
		}
		
		//--------------------------------------------------------------------
		//
		// Validation methods
		//
		//--------------------------------------------------------------------
		
		/**
		 * Take care of label changes and change in number of subdivisions 
		 */
		override protected function commitProperties():void 
		{
			super.commitProperties();
			//create new array to hold label instances
			if (_bLabelsChanged) {
				
				//get rid of all former labels
				if (tickLineLabelInstances) 
				{
					var labelInstance:Label;
					
					for (var i:int = 0; i< tickLineLabelInstances.length; i++)
					{
						labelInstance = tickLineLabelInstances[i];
						
						//will call partRemoved, make sure to remove any event listeners there if any have been added 
						this.removeDynamicPartInstance("tickLineLabel", labelInstance);
						
						//remove from skin manually (dynamic skin part are not added, removed by flex
						rulerGroup.removeElement(labelInstance);
						
						//explicit for readability, gc would get it anyway
						labelInstance = null;
					}
				}
				
				tickLineLabelInstances = new Array();
				//Add as many labels as needed to the skin using the dynamic skin part tickLineLabel
				for (var k:int = 0; k < (_labels.length); k++)
				{
					var label:Label = Label(this.createDynamicPartInstance("tickLineLabel"));
					label.text = _labels[k];
					tickLineLabelInstances[k] = label;
					rulerGroup.addElement(label);
				}
								
				rulerGroup.width = _labels.length * labelDistance;
				ruler.divisions = _labels.length;
				
				_bLabelsChanged = false;
			}
			
			if (_bLabelDistanceChanged)
			{
				rulerGroup.width = _labels.length * labelDistance;
				_bLabelDistanceChanged = false;
			}
			
			if (_bSubdivisionsChanged)
			{
				//proxy value pass it down the skin part
				_bSubdivisionsChanged = false;
				ruler.subdivisions = _subdivisions;
			}
		}
		
		/**
		 * Draw the skin and update the positions of the labels that have been added dynamically
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//update lables positions. See comment there
			updatePositionOfLabels();
		}
		
		/**
		 * Update the positions of the labels.
		 */
		protected function updatePositionOfLabels ():void 
		{
			if (tickLineLabelInstances && tickLineLabelInstances.length) 
			{
				var nLables:int = tickLineLabelInstances.length;
				for (var i:int = 0; i < nLables; i++)
				{
					var label:Label = tickLineLabelInstances[i];
					label.move(i * labelDistance + LABEL_PADDING, LABEL_PADDING);
				}
			}
		}
		
		/**
		 * Pointer indicates the mouse move 
		 */
		public function mouseMove(xValue:Number):void
		{
			ruler.mouseMoveHandle(xValue);
		}
	}
}