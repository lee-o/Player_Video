package cc.shic.display.particles 
{
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author david
	 */
	public class Particles extends Sprite
	{
		
		private var _target:DisplayObject;
		/**
		 * bitmap data de réference
		 */
		private var bmpd:BitmapData;
		/**
		 * Nombre de particules (500 à 2000 conseillé), plus il y a de particules plus ça rame.
		 */
		private var _quantity:int=500;
		/**
		 * toutes les particules
		 */
		private var particles:Vector.<Shape>;
		
		/**
		 * couleur des particules
		 */
		private var color:uint = 0x000000;
		
		/**
		 * couleur qu'il faut détecter dans tatrget et à laquelle les particules iront se coller
		 */
		public var colorDetection:uint = 0x000000;
		
		/**
		 * rayon maximum de positionnement des particules au départ de l'animation
		 */
		public var radius:int = 200;
		
		/**
		 * temps minimum de déplacement d'une particule
		 */
		public var minTime:Number = 0.2;
		/**
		 * temps maximal de déplacement d'une particule
		 */
		public var maxTime:Number = 0.7;
		
		/**
		 * taille minimum d'une particule
		 */
		public var minSize:Number = 1;
		
		/**
		 * taille maximum d'une particule
		 */
		public var maxSize:Number = 1;
		
		
		public function Particles(target:DisplayObject) 
		{
			this.target = target;
			createParticles();
		}
		/**
		 * démare l'animation de particules
		 */
		public function start():void {
			

			
			/**
			 * current particle
			 */
			var p:Shape;
			var size:Number;			
			var x:Number;
			var y:Number;
			var pt:Point
			
			for (var i:uint; i < particles.length; i++) {
				p = particles[i];
				size = getSizeParticle();
				pt = getPoint();
				x = pt.x;
				y = pt.y;
				
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					y:y
				} 
				);
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					x:x,
					width:size,
					height:size
				} 
				);
			}
		}
		
		public function randomize():void {
				
			/**
			 * current particle
			 */
			var p:Shape;
			var size:Number;			
			var x:Number;
			var y:Number;
			var pt:Point
			
			for (var i:uint; i < particles.length; i++) {
				p = particles[i];
				size = getSizeParticle();
				pt = getRandPosition();
				x = pt.x;
				y = pt.y;
				
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					y:y
				} 
				);
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					x:x,
					width:size,
					height:size
				} 
				);
			}
		}
		public function circularize():void {
				
			/**
			 * current particle
			 */
			var p:Shape;
			var size:Number;			
			var x:Number;
			var y:Number;
			var pt:Point
			
			for (var i:uint; i < particles.length; i++) {
				p = particles[i];
				size = getSizeParticle();
				pt = getCirclePosition();
				x = pt.x;
				y = pt.y;
				
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					y:y
				} 
				);
				TweenLite.to(p,  Utils.random2(minTime, maxTime), {
					x:x,
					width:size,
					height:size
				} 
				);
			}
		}
		/**
		 * crée les particules
		 */
		private function createParticles():void
		{
			if(!particles){
				particles = new Vector.<Shape>();
			}
			var p:Shape;
			var pt:Point;
			//cree les particules
			for (var i:uint=0; i < _quantity && particles.length<_quantity; i++) {
				p = new Shape();
				//p.blendMode = BlendMode.ADD;
				p.graphics.beginFill(color);
				p.graphics.drawCircle(0, 0, 10);
				p.width = p.height = getSizeParticle();
				addChild(p);
				pt= getRandPosition();
				p.x = pt.x;
				p.y = pt.y;
				particles.push(p);
			}
			
			//détruit les particules qui ne servent plus à rien
			while (particles.length > _quantity) {
				p = particles.pop();
				pt= getRandPosition();
				TweenLite.to(p, Utils.random2(minTime,maxTime), { 
					width:0,
					height:0,
					x:pt.x,
					y:pt.y,
					onComplete:function(p:Shape):void { 
						p.parent.removeChild(p); 
						p.graphics.clear(); 
						p = null; 
					},
					onCompleteParams:[p]
				});
			}
		}
		
		
		/**
		 * obtenir une position aléatoire pour une particule (la position se base sur le centre de target et radius)
		 * @return
		 */
		private function getRandPosition():Point {
			//return new Point(300, 300);
			var r:Number;
			var p:Point=new Point;
			r = Math.random() * 360;
			p.x = Math.cos(r) * Utils.random2(0,radius)+bmpd.width/2;
			p.y = Math.sin(r) * Utils.random2(0,radius)+bmpd.height/2;
			return p;
		}
		
		/**
		 * obtenir une position aléatoire circulaire pour une particule (la position se base sur le centre de target et radius)
		 * @return
		 */
		private function getCirclePosition():Point {
			//return new Point(300, 300);
			var r:Number;
			var p:Point=new Point;
			r = Math.random() * 360;
			p.x = Math.cos(r) * radius+bmpd.width/2;
			p.y = Math.sin(r) * radius + bmpd.height / 2;
			return p;
		}
		
		/**
		 * tente de renvoyer un point qui colle à target et color, si n'y parvient pas, renvoie une position aléatoire
		 * @return
		 */
		private function getPoint():Point {
			var i:uint;
			var x:int;
			var y:int;
			while (i++ < 2000) {
				x = Math.floor(Math.random() * bmpd.width);
				y = Math.floor(Math.random() * bmpd.height);
				if (isGoodPosition(x, y)) {
					return new Point(x,y);
				}
			}
			// si pas trouvé random position
			return getRandPosition();
		}
		
		/**
		 * obtenir la taille d'un particule
		 * @return
		 */
		private function getSizeParticle():Number {
			return Utils.random2(minSize, maxSize);
		}
		/**
		 * renvoie true si le point correspond à la couleur recherché
		 * @param	x
		 * @param	y
		 * @return
		 */
		private function isGoodPosition(x:Number,y:Number):Boolean {
			if (bmpd && bmpd.getPixel(x, y) == colorDetection ) {
				return true
			}else {
				return false;
			}
		}
		/**
		 * Display object qui sert de cible
		 */
		public function get target():DisplayObject { return _target; }
		public function set target(value:DisplayObject):void 
		{
			_target = value;
			if (bmpd) {
				bmpd.dispose();
			}
			bmpd = new BitmapData(_target.getBounds(target).right,_target.getBounds(target).bottom, false, 0xffff00);
			bmpd.draw(_target);
			
			/*
			 //preview bitmap
			var bmp:Bitmap = new Bitmap(bmpd);
			addChild(bmp);
			bmp.x = 300;
			*/
		}
		
		public function get quantity():int { return _quantity; }
		
		public function set quantity(value:int):void 
		{
			_quantity = value;
			createParticles();
			
		}
		
		
		
		
	}

}