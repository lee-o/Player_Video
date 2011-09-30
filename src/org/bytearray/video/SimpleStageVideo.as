/*
53 49 4D 50 4C 45 53 54 41 47 45 56 49 44 45 4F  
*/
	
package org.bytearray.video
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.media.VideoStatus;
	import flash.net.NetStream;
	
	import org.bytearray.video.events.SimpleStageVideoEvent;
	import org.bytearray.video.events.SimpleStageVideoToggleEvent;

	/**
	 * The SimpleStageVideo class allows you to leverage StageVideo trough a few lines of ActionScript.
	 * SimpleStageVideo automatically handles any kind of fallback, from StageVideo to video and vice versa.
	 * 
	 * @example
	 * To use SimpleStageVideo, use the following lines :
	 * <div class="listing">
	 * <pre>
	 *
	 * // specifies the size to conform (will always preserve ratio)
	 * sv = new SimpleStageVideo(500, 500);
	 * // dispatched when the NetStream object can be played
	 * sv.addEventListener(Event.INIT, onInit);
	 * // informs the developer about the compositing, decoding and if full GPU states
	 * sv.addEventListener(SimpleStageVideoEvent.STATUS, onStatus);
	 * </pre>
	 * </div>
	 * 
	 * 
	 * @author Thibault Imbert (bytearray.org)
	 * @version 1.1
	 */
	public class SimpleStageVideo extends Sprite
	{		
		private var _available:Boolean;
		private var _stageVideoInUse:Boolean;
		private var _classicVideoInUse:Boolean;
		private var _played:Boolean;
		private var _rc:Rectangle;
		
		private var _videoRect:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _reset:Rectangle = new Rectangle(0, 0, 0, 0);
		
		private var _initEvent:Event = new Event(Event.INIT);
		
		private var _ns:NetStream;
		private var _video:Video;
		private var _sv:StageVideo;
		
		private var _width:uint;
		private var _height:uint;
		
		/**
		 * 
		 * @param width The width of the screen, the video will fit this maximum width (while preserving ratio)
		 * @param height The height of the screen, the video will fit this maximum height (while preserving ratio)
		 * 
		 */		
		public function SimpleStageVideo(width:uint=640, height:uint=480)
		{
			_width = width, _height = height;
			init();
		}
		
		/**
		 * Forces the switch from Video to StageVideo and vice versa. 
		 * You should not have to use this API but can be useful for debugging purposes.
		 * @param on
		 * 
		 */		
		public function toggle(on:Boolean):void
		{			
			if (on && _available) 
			{
				_stageVideoInUse = true;
				if ( _sv == null && stage.stageVideos.length > 0 )
				{
					_sv = stage.stageVideos[0];
					_sv.addEventListener(StageVideoEvent.RENDER_STATE, onRenderState);
				}
				_sv.attachNetStream(_ns);
				dispatchEvent( new SimpleStageVideoToggleEvent ( SimpleStageVideoToggleEvent.TOGGLE, SimpleStageVideoToggleEvent.STAGEVIDEO ));
				if (_classicVideoInUse)
				{
					stage.removeChild ( _video );
					_classicVideoInUse = false;
				}
			} else 
			{
				if (_stageVideoInUse)
					_stageVideoInUse = false;
				_classicVideoInUse = true;
				_video.attachNetStream(_ns);
				dispatchEvent( new SimpleStageVideoToggleEvent ( SimpleStageVideoToggleEvent.TOGGLE, SimpleStageVideoToggleEvent.VIDEO ));
				addChild(_video);
			}
			
			if ( !_played ) 
			{
				_played = true;
				dispatchEvent(_initEvent);
			}
		}
		
		/**
		 * Resizes the video surfaces while always preserving the image ratio.
		 */		
		public function resize (width:uint=0, height:uint=0):void
		{	
			_width = width, _height = height;
			
			if ( _stageVideoInUse )	
				_sv.viewPort = getVideoRect(_sv.videoWidth, _sv.videoHeight);
			else 
			{
				_rc = getVideoRect(_video.videoWidth, _video.videoHeight);
				_video.width = _rc.width;
				_video.height = _rc.height;
				_video.x = _rc.x, _video.y = _rc.y;
			}
		}
		
		/**
		 * 
		 * @param stream The NetStream to use for the video.
		 * 
		 */		
		public function attachNetStream(stream:NetStream):void
		{
			_ns = stream;
		}
		
		/**
		 * 
		 * @return Returns the internal StageVideo object used if available.
		 * 
		 */		
		public function get stageVideo():StageVideo
		{
			return _sv;
		}
		
		/**
		 * 
		 * @return Returns the internal Video object used as a fallback.
		 * 
		 */		
		public function get video():Video
		{
			return _video;
		}
	
		/**
		 * 
		 * @return Returns the Stage Video availability.
		 * 
		 */		
		public function get available():Boolean
		{
			return _available;
		}

		/**
		 * 
		 * 
		 */		
		private function init():void
		{
			addChild(_video = new Video());
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageView);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onAddedToStage(event:Event):void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailable);
			_video.addEventListener(VideoEvent.RENDER_STATE, onRenderState);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onAddedToStageView(event:Event):void
		{	
			if (_classicVideoInUse)
				stage.addChildAt(_video, 0);
			else if ( _stageVideoInUse )
				_sv.viewPort = _videoRect;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onRemovedFromStage(event:Event):void
		{
			if ( !contains ( _video ) )
				addChild(_video);
			if ( _sv != null )
				_sv.viewPort = _reset;
		}

		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onStageVideoAvailable(event:StageVideoAvailabilityEvent):void
		{
			toggle(_available = (event.availability == StageVideoAvailability.AVAILABLE));
		}

		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onRenderState(event:Event):void
		{
			var hwDecoding:Boolean;
			
			if ( event is VideoEvent )
			{
				hwDecoding = (event as VideoEvent).status == VideoStatus.ACCELERATED;
				dispatchEvent( new SimpleStageVideoEvent ( SimpleStageVideoEvent.STATUS, hwDecoding, false, false ) );
			}else 
			{
				hwDecoding = (event as StageVideoEvent).status == VideoStatus.ACCELERATED;
				dispatchEvent( new SimpleStageVideoEvent ( SimpleStageVideoEvent.STATUS, hwDecoding, true, hwDecoding && true ));
			}
				
			resize(_width, _height);
		} 
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		private function getVideoRect(width:uint, height:uint):Rectangle
		{	
			var videoWidth:uint = width;
			var videoHeight:uint = height;
			var scaling:Number = Math.min ( _width / videoWidth, _height / videoHeight );
			
			videoWidth *= scaling, videoHeight *= scaling;
			
			var posX:Number = stage.stageWidth - videoWidth >> 1;
			var posY:Number = stage.stageHeight - videoHeight >> 1;
			
			_videoRect.x = posX;
			_videoRect.y = posY;
			_videoRect.width = videoWidth;
			_videoRect.height = videoHeight;
			
			return _videoRect;
		}
	}
}