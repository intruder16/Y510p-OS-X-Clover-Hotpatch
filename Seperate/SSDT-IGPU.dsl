// Automatic injection of IGPU properties

DefinitionBlock("", "SSDT", 2, "hack", "IGPU", 0)
{
    External(_SB.PCI0.IGPU, DeviceObj)

    Scope(_SB.PCI0.IGPU)
    {
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package ()
            {
                "device-id", Buffer () { 0x12, 0x04, 0x00, 0x00 }, 
                "AAPL,ig-platform-id", Buffer () { 0x06, 0x00, 0x26, 0x0A }, 
                "hda-gfx", Buffer () { "onboard-1" }, 
                "AAPL00,DualLink", Buffer () { 0x01, 0x00, 0x00, 0x00 }, 
                "model", Buffer () { "Intel HD 4600" },
            })
        }
    }
}
//EOF
