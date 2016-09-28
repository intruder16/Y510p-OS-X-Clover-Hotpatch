// Adding PNLF device for IntelBacklight.kext & Disable Nvidia graphics

//REVIEW: come up with table driven effort here...
#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9

DefinitionBlock("", "SSDT", 2, "hack", "PNLF", 0)
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
            // disable discrete graphics (Nvidia) if it is present
            External(\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
            If (CondRefOf(\_SB.PCI0.RP05.PEGP._OFF))
            {
                \_SB.PCI0.RP05.PEGP._OFF()
            }
        }
    }
}
//EOF
