// Created by : Intruder16
// Credits : RehabMan

// Replace Q11 & Q12 key functions for brightness

DefinitionBlock("", "SSDT", 2, "Y510p", "B-KEYS", 0)
{
    Device (RMKB)
    {
        Name (_HID, "RMKB0000")  // _HID: Hardware ID
    }
    
    External(_SB.PCI0.LPCB.EC0, DeviceObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_Q11, 0, NotSerialized)  // _Qxx: EC Query
        {
            Notify (RMKB, 0x114F)
            Notify (RMKB, 0x124F)
        }

        Method (_Q12, 0, NotSerialized)  // _Qxx: EC Query
        {
            Notify (RMKB, 0x114D)
            Notify (RMKB, 0x124D)
        }
    }
}
//EOF
