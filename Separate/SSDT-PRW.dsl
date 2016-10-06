// Created by : Intruder16
// Credits : RehabMan

// For solving instant wake by hooking GPRW or UPRW

DefinitionBlock("", "SSDT", 2, "Y510p", "PRW", 0)
{
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, Zero, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, Zero, }) }
        External(\XPRW, MethodObj)
        Return (XPRW(Arg0, Arg1))
    }
}
//EOF
