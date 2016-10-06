// Created by : Intruder16
// Credits : RehabMan

// Disabling XSEL

DefinitionBlock("", "SSDT", 2, "Y510p", "XSEL", 0)
{
    External(_SB.PCI0.XHC, DeviceObj)

    // In DSDT, native XSEL is renamed ZSEL
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.XSEL)
    {
        // do nothing
    }
}
//EOF
