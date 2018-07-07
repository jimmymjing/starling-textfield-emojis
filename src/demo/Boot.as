package demo {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;

[SWF(width="640", height="480", backgroundColor="#333333", frameRate="60")]
public class Boot extends Sprite {

    private var starling:Starling;

    public function Boot() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        loaderInfo.addEventListener(Event.COMPLETE, onLoaderInfoComplete);
    }

    private function onLoaderInfoComplete(event:Event):void {
        loaderInfo.removeEventListener(Event.COMPLETE, onLoaderInfoComplete);
        starling = new Starling(StarlingRoot, stage);
        starling.showStats = true;
        starling.supportHighResolutions = true;
        starling.start();
        stage.addEventListener(Event.RESIZE, onStageResize);
    }

    private function onStageResize(event:Event):void {
        if (!starling) return;
        starling.viewPort.width = starling.stage.stageWidth = stage.stageWidth;
        starling.viewPort.height = starling.stage.stageHeight = stage.stageHeight;
    }
}
}
