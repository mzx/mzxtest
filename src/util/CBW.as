package util
{
    public function CBW(value:Number, currentWidth:Number = NaN, basewidth:Number = 640):Number
    {
        return DPIUtils.convertBasedOnWidth(value, currentWidth, basewidth);
    }
}