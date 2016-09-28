// For solving instant wake by hooking GPRW or UPRW

DefinitionBlock("", "SSDT", 2, "hack", "PRW", 0)
{
    // In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // (or UPRW to XPRW)
    // As a result, calls to GPRW (or UPRW) land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, Zero, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, Zero, }) }
        External(\XPRW, MethodObj)
        Return (XPRW(Arg0, Arg1))
    }
}
//EOF
