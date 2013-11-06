package util
{
    import flash.system.Capabilities;

    public function CBW(value:Number, currentWidth:Number = NaN, basewidth:Number = 640):Number
    {
        return DPIUtils.convertBasedOnWidth(value, currentWidth, basewidth);
    }
}