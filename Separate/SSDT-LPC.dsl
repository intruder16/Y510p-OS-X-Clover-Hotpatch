// Fix unsupported 8-series LPC devices

DefinitionBlock("", "SSDT", 2, "hack", "LPC", 0)
{
    External(_SB.PCI0.LPCB, DeviceObj)

    Scope(_SB.PCI0.LPCB)
    {
        Method (_DSM, 4, NotSerialized)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package () { "compatible", "pci8086,9c43" })
        }
    }
}
//EOF
