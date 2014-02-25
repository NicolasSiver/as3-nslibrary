AS3 NSLibrary
=============

**AS3 NSLibrary** - utility classes for developing pure AS3 project. Library consists of several helper classes most valuable in the development of pure AS3 project: 

* TextField with invalidation, based on TLF to work with DF4 fonts; 
* DataManager — wrapper for the SharedObject; 
* RollButton, ControlledMovieClip - to work with animator, create fancy buttons and handmade auxiliary animations; 
* Transform - in pure AS3 project developer spends time on positioning and scaling components in the display list, Transform helps scale and align components in dedicated frames; 
* CurvedPath - creates complex shapes with rounded corners; 
* SFXEngine - manager for sound channels; 
* CodeListener, KeyListener - keyboard helpers, CodeListener gives ability to register magic words for callback.

## TextField

TextField based on Text Layout Framework, perceive this component as Label. Uses invalidation model to update its state.
With this DF4 TextField you will be able create pixel perfect designs without magic paddings or margins.

```as3
var factory:DF4TextFieldFactory = new DF4TextFieldFactory();
var fontName: String = "SomeFontName";
addChild(factory.createTextField("Some static text with DF4 fonts", factory.createTextFormat(fontName, 14, 0x333333, FontWeight.NORMAL, null, null, TextAlign.LEFT)));
```

## DataManager

DataManager is wrapper for SharedObject. It provides persistence. Its very easy to save some primitive values and restore them. For example, user disabled music, and don't want hear it anymore.

```as3
//Save state, where Cache.SOUNDS, Cache.DOMAIN - some strings
DataManager.getInstance().registerVar(player.isSoundsPlaying, Cache.SOUNDS, Cache.DOMAIN);

//Restore state
private function restoreSoundsState():Boolean {
    var isSet:Object = DataManager.getInstance().getValue(Cache.SOUNDS, Cache.DOMAIN);

    if (isSet != null) {
        var soundState:Boolean = Boolean(isSet);
        SoundMixer.soundTransform = new SoundTransform(int(soundState));
        return soundState;
    }

    return true;
}
```

## RollButton, ControlledMovieClip

MovieClip wrappers. RollButton is an easy way to create interactive MovieClip with RollOver/RollOut animation, all you need is to create MovieClip with hover animation. ControlledMovieClip encapsulates inner enter frame to give you ability reach Start/End/Concrete frame with one line of code.

```as3
//Specify base class as RollButton in the Flash Professional or create it:
var button: RollButton = new RollButton(new SomeMovieClip());

var myClip: ControlledMovieClip = new SomePredefinedMovieClip();
myClip.playUntil(88);
//after
myClip.goTo(ControlledMovieClip.START);
```

## Transform

Utility class for transformation calculations. Very helpful for situations when you need fit something with ScaleMode rule in dedicated zone, for example: downloaded image, or auto resizing components.

```as3
var width: uint = 800;
var height: uint = 600;
var someObject: Shape = new Shape();
var size: Rectangle;

//Dummy object, bigger than defined zone
someObject.graphics.beginFill(0x009900, 0.5);
someObject.graphics.drawRect(0, 0, 1024, 768);

//Letterbox - sets the width and height of the content
//as close to the container width and height as possible while maintaining aspect ratio
size = new Transform().getScaledSize(ScaleMode.LETTERBOX, width, height, someObject.width, someObject.height);

someObject.x = size.x;
someObject.y = size.y;
someObject.width = size.width;
someObject.height = size.height;
```

## CurvedPath

Graphics utility class for creating complex shapes with curved corners.
By the help of CurvedPath you will be able create such shapes:

![Simple Curved Shape](http://i.imgur.com/Kyopatq.png)

```as3
var curvedPath : CurvedPath = new CurvedPath();
curvedPath.create(Vector.<CurvedPoint>([new CurvedPoint(somePosX, somePosX, 0), new CurvedPoint(somePosX, somePosX, someRadius), …]));

//Use generated path data
graphics.beginFill(0x009900, 0.8);
graphics.drawPath(curvedPath.commands, curvedPath.data);
```
