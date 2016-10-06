// Created by : Intruder16
// Credits : RehabMan

// Adding PNLF device for IntelBacklight.kext & Disable Nvidia graphics

DefinitionBlock("", "SSDT", 2, "Y510p", "PNLF", 0)
{
    Device (_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        Name(_UID, 10)
        Name(_STA, 0x0B)
        Name(RMCF, Package()
        {
            "PWMMax", 0,
        })
        Method(_INI)
        {
            // Disable discrete graphics (Nvidia) if it is present
            
            External(\_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF))
            {
                \_SB.PCI0.PEG0.PEGP._OFF()
            }
        }
    }
}
//EOF
