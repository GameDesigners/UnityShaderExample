Shader "Custom/Base/PropertiesExample"
{
    Properties
    {
        _Int("Int Type",int)=1
        _Float("Float Type",float)=1.0
        _Range("Range Type(实际上是Float)",Range(1,10))=5
        _Color("Color Type",Color)=(1,1,1,1)
        _Vector("Vector Type",Vector)=(1,1,1,1)
        _2D("2D Type",2D) = "white"{}
        _Cube("Cube Type",Cube) = ""{}
        _3D("3D Type",3D) = "black"{}

        [Toggle(REDIFY_ON)] _Redify("Red?",Int)=0
    }

    Fallback "Diffuse"
}
