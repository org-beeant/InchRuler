package org.beeant.controls.InchRule
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import flashx.textLayout.formats.Float;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.beeant.controls.RuleComponent.HRule;
	import org.beeant.controls.RuleComponent.VRule;
	import org.beeant.skins.HRulerSkin;
	
	/**
	 * The InchRuleComponent is a Flex 4 compatible control, capable of receiving standard flex components
	 * @langversion 3.0
	 */
	public class InchRule extends Canvas
	{
		private static const RULE_THICKNESS:Number = 15;
		private static var DEFAULT_LABEL_DISTANCE:Number;
		
		if(flash.system.Capabilities.os == "mac")
		{
			DEFAULT_LABEL_DISTANCE = 75;
		}
		else
		{
			DEFAULT_LABEL_DISTANCE = 96;
		}
		
		/**
		 * Ruler Thickness
		 */ 
		private var _ruleThickness:Number = RULE_THICKNESS;
		
		/**
		 * Child Object
		 */ 
		private var child:DisplayObject;
		
		/**
		 * Horizantal Rule
		 */ 
		public var hRule:HRule = new HRule();
		
		/**
		 * Vertical Rule
		 */ 
		public var vRule:VRule = new VRule();
		
		/**
		 * Hrule and Vrule Coincidence box
		 */
		public var coincidenceBox:HBox = new HBox(); 
		
		/**
		 * Hrule and VRule Label Distance
		 */
		private var _labelDistance:Number = DEFAULT_LABEL_DISTANCE;
		
		/**
		 * Rule Status
		 */
		private var sRulerStatus:String = "inch";
		
		public function InchRule()
		{
			super();
			// Creation Complete Event
			this.clipContent = true;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
		}
		
		//------------------------------------------------------------------
		//
		// Properties
		//
		//------------------------------------------------------------------
		
		/**
		 * Ruler ThickNess 
		 */
		public function get rulerThickness():Number
		{
			return _ruleThickness;
		}
		
		public function set rulerThickness(value:Number):void
		{
			_ruleThickness = value;
		}
		
		/**
		 * Label Distance 
		 */
		public function get labelDistance():Number
		{
			return _labelDistance;
		}
		
		public function set labelDistance(value:Number):void
		{
			_labelDistance = value;
			hRule.labelDistance = _labelDistance;
			vRule.labelDistance = _labelDistance;
			_creationComplete();
		}
		
		/**
		 * Creation Complete Event
		 */ 
		protected function _creationComplete(event:FlexEvent = null):void
		{			
			coincidenceBox.x = 0;
			coincidenceBox.y = 0;
			coincidenceBox.width = rulerThickness;
			coincidenceBox.height = rulerThickness;
			
			hRule.width = this.unscaledWidth - rulerThickness;
			hRule.height = rulerThickness;
			hRule.labels = _horizantalLabel();
			hRule.invalidateProperties();
			hRule.invalidateDisplayList();
			hRule.x = rulerThickness;
			hRule.y = 0;
			
			vRule.width = rulerThickness;
			vRule.height = this.unscaledHeight - rulerThickness;
			vRule.labels = _verticalLabel();
			vRule.invalidateProperties();
			vRule.invalidateDisplayList();
			vRule.x = 0;
			vRule.y = rulerThickness;
			
			child.x = rulerThickness;
			child.y = rulerThickness;
			child.width = this.unscaledWidth - rulerThickness;
			child.height = this.unscaledHeight - rulerThickness;
			
		}
		
		/**
		 * Creates the Horizantal Labels 
		 */
		private function _horizantalLabel():Array
		{
			var label:Array = new Array();		
			if(Math.ceil((this.unscaledWidth - rulerThickness) / hRule.labelDistance) is Float)
			{
				var roundedInt:int = int((this.unscaledWidth - rulerThickness) / hRule.labelDistance);
			}
			for(var i:int = 0;i < Math.ceil((this.unscaledWidth - rulerThickness) / hRule.labelDistance) ; i++)
			{
				label.push(i);
			}
			return label;
		}
		
		/**
		 * Creates the Vertical Labels 
		 */
		private function _verticalLabel():Array
		{
			var label:Array = new Array();
			for(var i:int = 0;i < Math.ceil((this.unscaledHeight - rulerThickness) / vRule.labelDistance) ; i++)
			{
				label.push(i);
			}
			return label;
		}
		
		/**
		 * Overriden function creted children
		 */
		override protected function childrenCreated():void
		{
			var children:Array = this.getChildren();
			if(children[0] is InchRule)
			{
				return;
			}
			child = children[0] as DisplayObject;
			
			this.addChild(coincidenceBox);
			hRule.setStyle("skinClass",Class(org.beeant.skins.HRulerSkin));
			vRule.setStyle("skinClass",Class(org.beeant.skins.VRulerSkin));
			this.addChild(hRule);
			this.addChild(vRule);
		}
		
		/**
		 * Pointer indicates the mouse move
		 */ 
		public function mouseMoveHandler(xValue:Number, yValue:Number):void
		{
			hRule.mouseMove(xValue - this.x - rulerThickness);
			vRule.mouseMove(yValue - this.y - rulerThickness);
		}
		
		public function converstion(sToConvert:String):void
		{
			if(sToConvert == "inch")
			{
				if(sToConvert != sRulerStatus)
				{
					this.labelDistance = this.labelDistance * 2.54;
					sRulerStatus = "inch";
				}
			}
			else
			{
				if(sToConvert != sRulerStatus)
				{
					this.labelDistance = this.labelDistance / 2.54;
					sRulerStatus = "cm";
				}
			}
				
		}
	}
}