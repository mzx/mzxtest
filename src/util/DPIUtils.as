package util
{
    import feathers.system.DeviceCapabilities;

    import flash.system.Capabilities;

    import starling.display.DisplayObject;
    import starling.display.Stage;

    public class DPIUtils
    {
        public static var stage:Stage;

        public static function convertBasedOnWidth(value:Number, currentWidth:Number = NaN, basewidth:Number = 640):Number
        {

            if (isNaN(currentWidth))
            {
                currentWidth = stage.stageWidth;
            }
            return Math.floor(value * (currentWidth / basewidth));
        }

        public static function resize(object:DisplayObject, width:Number = NaN, height:Number = NaN):void
        {
            if (isNaN(width) && isNaN(height)) return;
            if (isNaN(width)) width = height *(object.width/ object.height);
            if (isNaN(height)) height = width * (object.height / object.width);

            object.width = width;
            object.height = height;
        }
    }
}