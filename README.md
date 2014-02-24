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

